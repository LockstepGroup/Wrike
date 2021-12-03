function New-WrikeWorkflow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [WrikeCustomStatus[]]$CustomStatus,

        [Parameter(Mandatory = $false)]
        [bool]$Hidden
    )

    BEGIN {
        $VerbosePrefix = "New-WrikeWorkflow:"
    }

    PROCESS {
        $ReturnObject = [WrikeWorkflow]::new()
        $ReturnObject.Id = $Id
        $ReturnObject.Name = $Name
        $ReturnObject.CustomStatus = $CustomStatus
        $ReturnObject.Hidden = $Hidden
    }

    END {
        $ReturnObject
    }
}
