$Bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
#Meet the following rules, ProtectionStatus not = On, No KeyProtectors exist and there is no VolumeStatus
If (($Bitlocker.ProtectionStatus.ToString() -ne 'On') -and (-Not ($Bitlocker.KeyProtector)) -and ($Bitlocker.VolumeStatus -eq 'FullyDecrypted')) {
    $True
} else {
    $False
}