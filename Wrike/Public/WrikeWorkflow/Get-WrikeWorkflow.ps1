function Get-WrikeWorkflow {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$Name
    )

    BEGIN {
        $VerbosePrefix = "Get-WrikeWorkflow:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'workflows/'
        $QueryParams.UriPath += $WorkflowId -join ','
        $QueryParams.Query = @{}
    }

    PROCESS {
        $Query = Invoke-WrikeApiQuery @QueryParams

        foreach ($entry in $Query.data) {
            $New = New-WrikeWorkflow -Id $entry.id -Name $entry.name -Hidden $entry.hidden
            $New.FullData = $entry

            foreach ($status in $entry.customstatuses) {
                $StatusParam = @{}
                $StatusParam.Id = $status.id
                $StatusParam.Name = $status.name
                $StatusParam.Color = $status.color
                $StatusParam.Group = $status.group
                $StatusParam.Hidden = $status.hidden

                $New.CustomStatus += New-WrikeCustomStatus @StatusParam
            }

            $ReturnObject += $New
        }
    }

    END {
        $global:WrikeServer.Workflows = $ReturnObject
        if ($Name) {
            $ReturnObject = $ReturnObject | Where-Object { $_.Name -eq $Name }
            if ($ReturnObject.Count -gt 0) {
                $ReturnObject
            } else {
                Throw "$VerbosePrefix Workflow not found: $Name"
            }
        } else {
            $ReturnObject
        }
    }
}
