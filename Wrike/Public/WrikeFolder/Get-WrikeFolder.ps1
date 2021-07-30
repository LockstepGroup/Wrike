function Get-WrikeFolder {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string[]]$FolderId
    )

    BEGIN {
        $VerbosePrefix = "Get-WrikeFolder:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'folders/'
        $QueryParams.UriPath += $FolderId -join ','
        $QueryParams.Query = @{}

        if (-not $global:WrikeServer.CustomFieldDefinitions) {
            Get-WrikeCustomField | Out-Null
        }

        if (-not $global:WrikeServer.Contacts) {
            Get-WrikeContact | Out-Null
        }
    }

    PROCESS {
        $Query = Invoke-WrikeApiQuery @QueryParams

        foreach ($entry in $Query.data) {
            $New = New-WrikeFolder
            $New.FullData = $entry
            $New.FolderId = $entry.id
            $New.Title = $entry.title
            $New.ChildId = $entry.childIds
            $New.ParentId = $entry.parentIds
            $New.SharedId = $entry.sharedIds
            $New.WorkflowId = $entry.workflowId
            $New.Scope = $entry.scope
            $New.Description = $entry.description
            $New.HasAttachment = $entry.hasAttachments
            $New.Permalink = $entry.permalink
            $New.CreateDate = $entry.createdDate
            $New.UpdateDate = $entry.updatedDate

            if ($entry.project) {
                $New.FolderType = 'Project'
                $New.AuthorId = $entry.project.authorId
                $New.OwnerId = $entry.project.ownerIds
                $New.Status = $entry.project.status
                $New.CustomStatusId = $entry.project.customStatusId
                $New.CreateDate = $entry.project.createdDate
                if ($entry.project.startDate) {
                    $New.StartDate = $entry.project.startDate
                }
                if ($entry.project.endDate) {
                    $New.FinishDate = $entry.project.endDate
                }
            } else {
                $New.FolderType = 'Folder'
            }


            # process custom fields
            foreach ($field in $entry.customFields) {
                $FieldLookup = $global:WrikeServer.CustomFields | Where-Object { $_.CustomFieldId -eq $field.id }

                $FieldDefinition = New-WrikeCustomField #Select-Object Id, Title, Value
                $FieldDefinition.CustomFieldId = $field.id
                $FieldDefinition.Title = $FieldLookup.Title
                $FieldDefinition.Value = $field.value

                $New.CustomField += $FieldDefinition
            }

            $ReturnObject += $New
        }
    }

    END {
        $ReturnObject
    }
}
