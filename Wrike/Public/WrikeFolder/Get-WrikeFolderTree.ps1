function Get-WrikeFolderTree {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$FolderId
    )

    BEGIN {
        $VerbosePrefix = "Get-WrikeFolderTree:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'folders'
        $QueryParams.Query = @{}

        if ($FolderId) {
            $QueryParams.UriPath += '/' + $FolderId + '/folders'
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
            $New.Scope = $entry.scope

            if ($entry.project) {
                $New.FolderType = 'Project'
                $New.AuthorId = $entry.project.authorId
                $New.OwnerId = $entry.project.ownerIds
                $New.Status = $entry.project.status
                $New.CustomStatusId = $entry.project.customStatusId
                $New.CreateDate = $entry.project.createdDate
            } else {
                $New.FolderType = 'Folder'
            }

            $ReturnObject += $New
        }
    }

    END {
        $ReturnObject
    }
}
