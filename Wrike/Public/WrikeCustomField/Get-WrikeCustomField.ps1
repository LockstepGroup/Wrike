function Get-WrikeCustomField {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "Get-WrikeCustomField:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'customfields'
        $QueryParams.Query = @{}
    }

    PROCESS {
        $Query = Invoke-WrikeApiQuery @QueryParams

        foreach ($entry in $Query.data) {
            $New = New-WrikeCustomField
            $New.FullData = $entry
            $New.CustomFieldId = $entry.id
            $New.Title = $entry.title
            $New.SharedId = $entry.sharedIds
            $New.Settings = $entry.settings

            $ReturnObject += $New
        }
    }

    END {
        $global:WrikeServer.CustomFields = $ReturnObject
        $ReturnObject
    }
}
