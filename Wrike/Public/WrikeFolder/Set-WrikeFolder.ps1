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

        if ($null -ne $WrikeFolder.FolderId) {
            $QueryParams.Method = 'PUT'
            $QueryParams.UriPath = 'folders/' + $WrikeFolder.FolderId
            $ExistingFolder = Get-WrikeFolder -FolderId $WrikeFolder.FolderId
        } else {
            $QueryParams.UriPath = 'folders/' + $WrikeFolder.ParentId + '/folders'
            $QueryParams.Method = 'POST'
        }

        $QueryParams.Query = @{}

        # title
        if ($WrikeFolder.Title) {
            $QueryParams.Query.title = $WrikeFolder.Title
        } else {
            Throw "$VerbosePrefix no Title set, all folders/projects require a Title"
        }

        # customfields
        if ($WrikeFolder.CustomField.Count -gt 0) {
            #$ThisBodyString = @()
            $ThisBodyArray = @()
            foreach ($field in $WrikeFolder.CustomField) {
                if (-not $field.CustomFieldId) {
                    if ($WrikeServer.CustomFields.Count -eq 0) {
                        Get-WrikeCustomField | Out-Null
                    }
                    $field.CustomFieldId = ($WrikeServer.CustomFields | Where-Object { $_.Title -eq $field.Title }).CustomFieldId
                }
                #$ThisBodyString += '{"id":"' + $field.CustomFieldId + '","value":"' + $field.Value + '"}'
                $ThisBodyArray += @{
                    'id'    = $field.CustomFieldId
                    'value' = $field.Value
                }
            }
            #$QueryParams.Query.customFields = '[' + ($ThisBodyString -join ',') + ']'
            $QueryParams.Query.customFields = $ThisBodyArray | ConvertTo-Json -Compress
        }

        # project properties
        $ProjectBodyString = @()

        # customStatusId
        if ($WrikeFolder.CustomStatusId) {
            $ThisBodyString = '"customStatusId":"'
            $ThisBodyString += $WrikeFolder.CustomStatusId
            $ThisBodyString += '"'
            $ProjectBodyString += $ThisBodyString
        }

        # status
        if ($WrikeFolder.Status) {
            $ThisBodyString = '"status":"'
            $ThisBodyString += $WrikeFolder.Status
            $ThisBodyString += '"'
            $ProjectBodyString += $ThisBodyString
        }

        # start date
        if ($WrikeFolder.StartDate -and ($WrikeFolder.StartDate -ne (Get-Date 1/1/0001))) {
            $ThisBodyString = '"startDate":"'
            $ThisBodyString += Get-Date -Date $WrikeFolder.StartDate -Format yyyy-MM-dd
            $ThisBodyString += '"'
            $ProjectBodyString += $ThisBodyString
        }

        # FinishDate
        if ($WrikeFolder.FinishDate -and ($WrikeFolder.FinishDate -ne (Get-Date 1/1/0001))) {
            $ThisBodyString = '"endDate":"'
            $ThisBodyString += Get-Date -Date $WrikeFolder.FinishDate -Format yyyy-MM-dd
            $ThisBodyString += '"'
            $ProjectBodyString += $ThisBodyString
        }

        if ($ProjectBodyString.Count -gt 0) {
            $ProjectBodyString = $ProjectBodyString -join ','
            $QueryParams.Query.project = '{' + $ProjectBodyString + '}'
        }

        $Query = Invoke-WrikeApiQuery @QueryParams
        $NewFolderId = $Query.data.id

        # check for parentid changes on existing folders
        if ($ExistingFolder) {
            $MissingParentIds = $WrikeFolder.ParentId | Where-Object { $ExistingFolder.ParentId -notcontains $_ }
            $ParentIdsToBeRemoved = $ExistingFolder.ParentId | Where-Object { $WrikeFolder.ParentId -notcontains $_ }

            if ($MissingParentIds.Count -gt 0) {
                foreach ($ParentId in $MissingParentIds) {
                    Write-Verbose "$VerbosePrefix Missing Parent ID: $ParentId"
                }

                $QueryParams = @{}
                $QueryParams.UriPath = 'folders/' + $NewFolderId
                $QueryParams.Query = @{}
                $QueryParams.Method = 'PUT'

                $QueryParams.Query.addParents = '[' + ($MissingParentIds -join ',') + ']'
                $Query = Invoke-WrikeApiQuery @QueryParams
            }

            if ($ParentIdsToBeRemoved.Count -gt 0) {
                foreach ($ParentId in $ParentIdsToBeRemoved) {
                    Write-Verbose "$VerbosePrefix Parent ID to be Removed: $ParentId"
                }

                $QueryParams = @{}
                $QueryParams.UriPath = 'folders/' + $NewFolderId
                $QueryParams.Query = @{}
                $QueryParams.Method = 'PUT'

                $QueryParams.Query.removeParents = '[' + ($ParentIdsToBeRemoved -join ',') + ']'
                $Query = Invoke-WrikeApiQuery @QueryParams
            }
        }

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