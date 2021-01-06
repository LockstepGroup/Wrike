Class WrikeFolder {
    [string]$FolderId
    [string]$Title

    [string]$Scope
    [string]$FolderType       # Project/Folder
    [string]$Description

    [string[]]$ChildId
    [string[]]$ParentId
    [string[]]$SharedId
    [string]$WorkflowId

    [bool]$HasAttachment
    [string]$Permalink

    # project info
    [string]$AuthorId
    [string[]]$OwnerId
    [string]$Status
    [string]$CustomStatusId

    [datetime]$UpdateDate
    [datetime]$CreateDate
    [datetime]$StartDate
    [datetime]$FinishDate

    # custom fields
    [array]$CustomField

    # fulldata for reference
    $FullData

    #region Initiators
    ########################################################################

    # empty initiator
    WrikeFolder() {
    }

    ########################################################################
    #endregion Initiators
}
