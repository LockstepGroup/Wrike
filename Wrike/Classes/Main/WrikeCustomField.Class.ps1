Class WrikeCustomField {
    [string]$CustomFieldId
    [string]$Title
    [string]$Type
    [string[]]$SharedId
    $Value
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
