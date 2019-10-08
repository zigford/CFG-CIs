$BiosPassword = 'PasswordHere'

function Get-SecureBootEnabledState {
    [CmdLetBinding()]
    Param()

    $Value = Get-WMIObject -Namespace root\dcim\sysman -Class DCIM_BiosEnumeration | Where-Object {$_.AttributeName -eq "Secure Boot"}
    Switch ($Value.CurrentValue) {
        2 {$True}
        Default {$False}
    }
}

function Enable-SecureBoot {
    [CmdLetBinding()]
    Param()

    $BiosService = Get-WMIObject -Namespace root\dcim\sysman -Class DCIM_BiosService
    $Result = $BiosService.SetBiosAttributes($null,$null,"Secure Boot","2",$BiosPassword)
    If ($Result.SetResult[0] -eq 0) {
        Write-Verbose "Succesfully enabled Secure Boot"
    } else {
        Write-Error "Failed to enable secure boot"
    }
}

$Bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
If ($Bitlocker.ProtectionStatus.ToString() -eq 'On') {
    Write-Verbose 'Suspending Bitlocker'
    Suspend-BitLocker -MountPoint $env:SystemDrive -ErrorAction Stop | Out-Null
    Write-Verbose 'Bitlocker Suspended'
} Else {
    Write-Verbose 'Bitlocker protections already disabled'
}

Enable-SecureBoot