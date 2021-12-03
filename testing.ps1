[CmdletBinding()]
Param (
)
ipmo ./Wrike -Force

Connect-WrikeServer -ApiToken $global:WrikeToken
$WorkFlows = Get-WrikeWorkFlow

$ThisWorkflow = Get-WrikeWorkFlow -Name 'Lockstep Standard'

$ThisProject = Get-WrikeFolder -FolderId 'IEAATVUZI4P6WZSW'

$ThisProject