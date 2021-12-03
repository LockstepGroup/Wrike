function New-WrikeCustomStatus {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Id,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Color,

        [Parameter(Mandatory = $false)]
        [string]$Group,

        [Parameter(Mandatory = $false)]
        [bool]$Hidden

    )

    BEGIN {
        $VerbosePrefix = "New-WrikeCustomStatus:"
    }

    PROCESS {
        $ReturnObject = [WrikeCustomStatus]::new()
        $ReturnObject.Id = $Id
        $ReturnObject.Name = $Name
        $ReturnObject.Color = $Color
        $ReturnObject.Group = $Group
        $ReturnObject.Hidden = $Hidden
    }

    END {
        $ReturnObject
    }
}


[string]$Id
[string]$Name
[string]$Color
[string]$Group

[bool]$StandardName
[bool]$Standard
[bool]$Hidden