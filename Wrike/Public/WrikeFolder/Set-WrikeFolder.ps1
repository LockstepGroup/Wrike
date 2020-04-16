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
            $QueryParams.customFields =
            $ThisBodyString = ''
            foreach ($field in $WrikeFolder.CustomField) {
                $ThisBodyString += '{"id":"' + $field.Id + '","value":"' + $field.Value + '"}'
            }
            $QueryParams.Query.customFields = '[' + $ThisBodyString + ']'
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

        $Query = Invoke-WrikeApiQuery @QueryParams
        $ReturnObject += Get-WrikeFolder -FolderId $Query.data.id
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