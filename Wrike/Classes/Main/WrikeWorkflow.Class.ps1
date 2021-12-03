Class WrikeWorkflow {
    [string]$Id
    [string]$Name
    [WrikeCustomStatus[]]$CustomStatus

    [bool]$Standard
    [bool]$Hidden

    # fulldata for reference
    $FullData

    #region Initiators
    ########################################################################

    # empty initiator
    WrikeWorkflow() {
    }

    ########################################################################
    #endregion Initiators
}
