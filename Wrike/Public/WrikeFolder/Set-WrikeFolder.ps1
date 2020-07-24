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



#curl -g -X POST -H 'Authorization: bearer asdf' -d 'metadata=[{"key":"testMetaKey","value":"testMetaValue"}]
#&customFields=[{"id":"IEAAADFOJUAAAACH","value":"testValue"}]
#&description=Test description
#&project={"ownerIds":["KUAAAF4P"],"status":"Red","startDate":"2020-03-25","endDate":"2020-04-01"}
#&title=Test folder
#&shareds=["KUAAAF4P"]' 'https://www.wrike.com/api/v4/folders/IEAAADFOI4AB5LMX/folders'

#curl -g -X PUT -H 'Authorization: bearer eyJ0dCI6InAiLCJhbGciOiJIUzI1NiIsInR2IjoiMSJ9.eyJkIjoie1wiYVwiOjMyNDYsXCJpXCI6OTY1LFwiY1wiOjEyMjYsXCJ2XCI6XCJcIixcInVcIjo2MDMxLFwiclwiOlwiVVNcIixcInNcIjpbXCJOXCIsXCJJXCIsXCJXXCIsXCJGXCIsXCJLXCIsXCJVXCIsXCJDXCIsXCJBXCIsXCJMXCIsXCJCXCIsXCJEXCJdLFwielwiOltdLFwidFwiOjE1ODUxMzk4MDgwMDB9IiwiZXhwIjoxNTg1MTM5ODA4LCJpYXQiOjE1ODUxMzYyMDh9.IHV1owDzlKvpKwZCAyZaYVOBFPmi115oFgksKVFbxSo' -d 'metadata=[{"key":"testMetaKey","value":"testMetaValue"}]&addShareds=["KUAAAF4P"]&customFields=[{"id":"IEAAADFOJUAAAACH","value":"testValue"}]&description=New description&project={"ownersAdd":["KUAAAF4P"],"ownersRemove":["KUAAAF4Q"],"status":"Red","startDate":"2020-03-25","endDate":"2020-04-01"}&addParents=["IEAAADFOI7777777"]&title=New title' 'https://www.wrike.com/api/v4/folders/IEAAADFOI4AB5LMX'