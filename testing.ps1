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

$ThisContact = Get-WrikeContact -FirstName 'Brian' -LastName 'Addicks'
$ThisContact = $ThisContact | Where-Object { $_.EmailAddress }

$TheseCustomFields = @{}
$TheseCustomFields.'Project #' = 1000
$TheseCustomFields.'Budgeted Hours' = '80:00'
$TheseCustomFields.'Updates/Notes' = 'To be assigned'
$TheseCustomFields.'Project Manager' = $ThisContact.ContactId

$NewProject.CustomField += New-WrikeCustomField -Title 'Project #' -Value 1000
$NewProject.CustomField += New-WrikeCustomField -Title 'Budgeted Hours' -Value '80:00'
$NewProject.CustomField += New-WrikeCustomField -Title 'Updates/Notes' -Value 'To be assigned'
$NewProject.CustomField += New-WrikeCustomField -Title 'Project Manager' -Value $ThisContact.ContactId

#$SetProject = $NewProject | Set-WrikeFolder
<#
$ActiveProjects = @()
$ChildFolders = $ActiveFolder.ChildId
for ($i = 0; $i -lt $ChildFolders.Count; $i += 100) {
    $Start = $i
    $Stop = $i + 99
    $ActiveProjects += Get-WrikeFolder -FolderId $ChildFolders[$Start..$Stop]
}

$ActiveProjects = $ActiveProjects | ? { $_.FolderType -eq 'Project' }

$ProjectOutput = @()
foreach ($project in $ActiveProjects) {
    $new = $project | Copy-PsObjectWithNewProperty -NewProperty 'ProjectNumber', 'LastUpdated', 'Update'
    $new.ProjectNumber = ($project.CustomField | Where-Object { $_.Title -eq 'Project #' } ).Value
    $new.LastUpdated = ($project.CustomField | Where-Object { $_.Title -eq 'Last Updated' } ).Value
    $new.Update = ($project.CustomField | Where-Object { $_.Title -eq 'Updates/Notes' } ).Value
    $ProjectOutput += $new
}
 #>
<#
foreach ($child in $ActiveFolder.ChildId) {
    $folder = $FolderTree
    if ($folder.FolderType -eq 'Project') {
        $new = "" | Select-Object Name, ProjectNumber, LastUpdated, Update
        $new.Name = $folder.Title
        $new.ProjectNumber = ($folder.CustomField | Where-Object {$_.Title -eq 'Project #' } ).Value
        $new.LastUpdated = ($folder.CustomField | Where-Object {$_.Title -eq 'Last Updated' } ).Value
        $new.Update = ($folder.CustomField | Where-Object {$_.Title -eq 'Updates/Notes' } ).Value
        $ActiveProjects += $new
    }
}


 #>