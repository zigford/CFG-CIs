$Bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
If ($Bitlocker.ProtectionStatus.ToString() -eq 'On') {
    $true
} else {
    $False
}