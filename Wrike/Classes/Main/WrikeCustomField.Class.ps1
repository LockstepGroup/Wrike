Class WrikeCustomField {
    [string]$CustomFieldId
    [string]$Title
    [string]$Type
    [string[]]$SharedId
    $Settings

    # fulldata for reference
    $FullData

    #region Initiators
    ########################################################################

    # empty initiator
    WrikeCustomField() {
    }

    ########################################################################
    #endregion Initiators
}
