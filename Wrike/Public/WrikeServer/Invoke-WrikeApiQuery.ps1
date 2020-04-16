function Invoke-WrikeApiQuery {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string]$UriPath,

        [Parameter(Mandatory = $false, Position = 1)]
        [hashtable]$Query = @{}
    )

    BEGIN {
        $VerbosePrefix = "Invoke-WrikeApiQuery:"
    }

    PROCESS {
        if (-not $Global:WrikeServer) {
            Throw "$VerbosePrefix no active connection to Wrike, please use Connect-WrikeServer to get started."
        } else {
            $Global:WrikeServer.UriPath = $UriPath
            $ReturnObject = $Global:WrikeServer.invokeApiQuery($Query)
        }
    }

    END {
        $ReturnObject
    }
}