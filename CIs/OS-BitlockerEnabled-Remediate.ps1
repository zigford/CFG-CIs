function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True,
            Mandatory=$True
        )]$Message,
        [Parameter(
            Mandatory=$True
        )]$EventID,
        [ValidateSet(
            'Information',
            'Error'
        )]$Type='Information',
        $Source='ComplianceEncryptionRemediation'
    )
    Begin{
        if(![System.Diagnostics.EventLog]::SourceExists($Source)) {
            New-EventLog -LogName Application -Source $Source 
        }
    }
    Process{
        Write-EventLog -LogName Application -Source $Source -EntryType $Type -EventId $EventID -Message $Message
    }
}
$EncryptionMethod = 6 # See https://msdn.microsoft.com/en-us/library/windows/desktop/aa376432(v=vs.85).aspx
$EncryptionNamespace = "root\cimv2\Security\MicrosoftVolumeEncryption"
$EncryptableVolume = Get-WmiObject -Query "SELECT * FROM Win32_EncryptableVolume WHERE DriveLetter='C:'" -Namespace $EncryptionNamespace
$ProtectionStatus = ($EncryptableVolume.GetProtectionStatus()).ProtectionStatus
Switch($ProtectionStatus) {
    0 {
        $ConversionStatus = ($EncryptableVolume.GetConversionStatus()).ConversionStatus
	    Switch($ConversionStatus) {
            0 {
                $return = $EncryptableVolume.ProtectKeyWithTPM("TPM Protection", $null) # Adds TPM Unlock
                if($return.ReturnValue -ne 0) {
                    logMsg "Failed to add TPM key protector" 500 -Type Error
                    [void]$EncryptableVolume.DeleteKeyProtectors()
                    $state = $False
                    break
                }
                $return = $EncryptableVolume.ProtectKeyWithNumericalPassword() # Adds a recovery password
                if($return.ReturnValue -ne 0) {
                    logMsg "Failed to add recovery password" 500 -Type Error
                    [void]$EncryptableVolume.DeleteKeyProtectors()
                    $state = $False
                    break
                }
                $return = $EncryptableVolume.BackupRecoveryInformationToActiveDirectory($EncryptableVolume.GetKeyProtectors(3).VolumeKeyProtectorID) #Backup recovery key to AD
                if($return.ReturnValue -ne 0) {
                    logMsg "Failed to backup recovery key to AD" 500 -Type Error
                    [void]$EncryptableVolume.DeleteKeyProtectors()
                    $state = $False
                    break
                }
                $return = $EncryptableVolume.Encrypt($EncryptionMethod)
                if($return.ReturnValue -eq 0) { 
                    logMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully enabled encryption." 501
                    $state = $True
                } else {  
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to enable encryption on this device, clearing protectors." 502 -Type Error
                    $state = $False
                    [void]$EncryptableVolume.DeleteKeyProtectors()
                }
            }   
            1 { 
                $return = $EncryptableVolume.EnableKeyProtectors()
                if($return.ReturnValue -eq 0) { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully enabled protection." 503
                    $state = $True
                } else {
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to enable protection." 504 -Type Error
                    $state = $False
                }
            }
            { ($_ -eq 3) -or ($_ -eq 5) } {
                $return = $EncryptableVolume.Encrypt($EncryptionMethod)
                if($return.ReturnValue -eq 0) { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully enabled encryption." 505
                    $state = $True
                } else { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to enable encryption." 506 -Type Error
                    $state = $False
                }
            }
            4 { 
                $return = $EncryptableVolume.ResumeConversion()
                if($return.ReturnValue -eq 0) { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully resumed conversion." 507
                    $state = $True
                } else {
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to resume conversion." 508 -Type Error
                    $state = $False
                }
            }
        }
    }
    1 {
        LogMsg "Return Value: $($return.ReturnValue)`r`nProtection already enabled." 500
        $state = $True
    }
}