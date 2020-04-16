function Connect-WrikeServer {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$ApiToken
    )

    BEGIN {
        $VerbosePrefix = "Connect-WrikeServer:"
    }

    PROCESS {
        $ReturnObject = New-WrikeServer -ApiToken $ApiToken
        #TODO: need to add a test connection
    }

    END {
        $Global:WrikeServer = $ReturnObject
    }
}
