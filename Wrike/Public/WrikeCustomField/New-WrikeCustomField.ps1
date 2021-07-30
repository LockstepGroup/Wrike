function New-WrikeCustomField {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$CustomFieldId,

        [Parameter(Mandatory = $false)]
        [string]$Title,

        [Parameter(Mandatory = $false)]
        $Value
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeCustomField:"
    }

    PROCESS {
        $ReturnObject = [WrikeCustomField]::new()
        $ReturnObject.CustomFieldId = $CustomFieldId
        $ReturnObject.Title = $Title
        $ReturnObject.Value = $Value
    }

    END {
        $ReturnObject
    }
}