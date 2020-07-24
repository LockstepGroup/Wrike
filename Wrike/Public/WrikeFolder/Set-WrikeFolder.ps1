function Set-WrikeFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [WrikeFolder]$WrikeFolder
    )

    BEGIN {
        $VerbosePrefix = "Set-WrikeFolder:"
        $ReturnObject = @()
    }

    PROCESS {
        # adjust for multiple parent folders

        if ($WrikeFolder.ParentId.Count -gt 1) {
            $AdditionalParents = $WrikeFolder.ParentId | Where-Object { $_ -ne $WrikeFolder.ParentId[0] }
            $WrikeFolder.ParentId = $WrikeFolder.ParentId[0]
        } else {
            $AdditionalParents = $null
        }

        $QueryParams = @{}
        $QueryParams.UriPath = 'folders/' + $WrikeFolder.ParentId + '/folders'
        $QueryParams.Query = @{}
        $QueryParams.Method = 'POST'

        # title
        if ($WrikeFolder.Title) {
            $QueryParams.Query.title = $WrikeFolder.Title
            $ThisBodyString = 'title=' + $WrikeFolder.Title
        } else {
            Throw "$VerbosePrefix no Title set, all folders/projects require a Title"
        }

        # customfields
        if ($WrikeFolder.CustomField.Count -gt 0) {
            $ThisBodyString = @()
            foreach ($field in $WrikeFolder.CustomField) {
                if (-not $field.CustomFieldId) {
                    if ($WrikeServer.CustomFields.Count -eq 0) {
                        Get-WrikeCustomField | Out-Null
                    }
                    $field.CustomFieldId = ($WrikeServer.CustomFields | Where-Object { $_.Title -eq $field.Title }).CustomFieldId
                }
                $ThisBodyString += '{"id":"' + $field.CustomFieldId + '","value":"' + $field.Value + '"}'
            }
            $QueryParams.Query.customFields = '[' + ($ThisBodyString -join ',') + ']'
        }

        # project properties
        $ProjectBodyString = @()
        if ($WrikeFolder.Status) {
            $ThisBodyString = '"status":"'
            $ThisBodyString += $WrikeFolder.Status
            $ThisBodyString += '"'
            $ProjectBodyString += $ThisBodyString
        }

        if ($ProjectBodyString.Count -gt 0) {
            $ProjectBodyString = $ProjectBodyString -join ','
            $QueryParams.Query.project = '{' + $ProjectBodyString + '}'
        }

        $global:test = $QueryParams

        $Query = Invoke-WrikeApiQuery @QueryParams
        $NewFolderId = $Query.data.id

        # add additional parent folders
        if ($AdditionalParents) {
            $QueryParams = @{}
            $QueryParams.UriPath = 'folders/' + $NewFolderId
            $QueryParams.Query = @{}
            $QueryParams.Method = 'PUT'

            $QueryParams.Query.addParents = '[' + ($AdditionalParents -join ',') + ']'
            $Query = Invoke-WrikeApiQuery @QueryParams
        }

        $ReturnObject += Get-WrikeFolder -FolderId $NewFolderId
    }

    END {
        $ReturnObject
    }
}