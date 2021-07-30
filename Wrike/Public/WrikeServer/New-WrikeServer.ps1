function New-WrikeServer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$ApiToken
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeServer:"
    }

    PROCESS {
        $ReturnObject = [WrikeServer]::new()
        if ($ApiToken) {
            $ReturnObject.ApiToken = $ApiToken
        }
    }

    END {
        $ReturnObject
    }
}
