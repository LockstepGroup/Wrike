[CmdletBinding()]
Param (
)
ipmo ./Wrike -Force

Connect-WrikeServer -ApiToken $global:WrikeToken

$CustomFields = Get-WrikeCustomField
$FolderTree = Get-WrikeFolderTree
$ActiveFolder = $FolderTree | ? { $_.title -eq 'Active' }
$ActiveFolder = Get-WrikeFolder -FolderId $ActiveFolder.FolderId
$ProjectFolder = $FolderTree | ? { $_.title -eq 'RHA - Extreme Core Replacement' }
$ProjectFolder = Get-WrikeFolder -FolderId $ProjectFolder.FolderId