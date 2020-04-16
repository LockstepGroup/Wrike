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

$NeedsResourceFolder = $FolderTree | ? { $_.title -eq 'Needs Resource' }
$NewProject = New-WrikeFolder
$NewProject.Title = 'LTG - Test Project'
$NewProject.Status = 'Yellow'
$NewProject.ParentId = $NeedsResourceFolder.FolderId
$SetProject = $NewProject | Set-WrikeFolder