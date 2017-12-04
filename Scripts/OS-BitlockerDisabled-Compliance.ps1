
$Bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction SilentlyContinue
#Meet the following rules, ProtectionStatus not = On, No KeyProtectors exist and there is no VolumeStatus. Warning. This script may error if 
If ($BitLocker) {
    If (($Bitlocker.ProtectionStatus.ToString() -ne 'On') -and (-Not ($Bitlocker.KeyProtector)) -and ($Bitlocker.VolumeStatus -eq 'FullyDecrypted')) {
        # return true here because protection is not on and volue is fullydecrypted
        return $True
    } else {
        return $False
    }
} else {
    # return true here because the drive cannot be encrypted anyway
    return $True
}