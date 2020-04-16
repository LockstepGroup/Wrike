function New-WrikeFolder {
    [CmdletBinding()]
    Param (
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeFolder:"
    }

    PROCESS {
        $ReturnObject = [WrikeFolder]::new()
    }

    END {
        $ReturnObject
    }
}
