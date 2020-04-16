function New-WrikeContact {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeContact:"
    }

    PROCESS {
        $ReturnObject = [WrikeContact]::new()
    }

    END {
        $ReturnObject
    }
}
