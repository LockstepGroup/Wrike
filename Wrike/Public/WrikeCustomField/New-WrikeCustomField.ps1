function New-WrikeCustomField {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeCustomField:"
    }

    PROCESS {
        $ReturnObject = [WrikeCustomField]::new()
    }

    END {
        $ReturnObject
    }
}
