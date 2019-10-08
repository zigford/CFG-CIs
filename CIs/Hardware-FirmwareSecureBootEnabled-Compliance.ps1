function Get-SecureBootEnabledState {
    [CmdLetBinding()]
    Param()

    $Value = Get-WMIObject -Namespace root\dcim\sysman -Class DCIM_BiosEnumeration | Where-Object {$_.AttributeName -eq "Secure Boot"}
    Switch ($Value.CurrentValue) {
        2 {$True}
        Default {$False}
    }
}

Get-SecureBootEnabledState
