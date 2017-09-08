function Get-DellBiosPasswordRequirement {
    [CmdLetBinding()]
    Param()
    $Query = 'Select * from DCIM_BiosEnumeration Where AttributeName = "Admin Setup Lockout"'
    Switch ((Get-WmiObject -Namespace root\dcim\sysman -Query $Query).CurrentValue) {
        1 {$False}
        2 {$True}
        Default {}
    }
}

Get-DellBiosPasswordRequirement