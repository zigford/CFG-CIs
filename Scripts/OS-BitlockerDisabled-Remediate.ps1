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
        # Currently, the device is either decrypted or in the process of being decrypted.
        # or is partially Decrypted. We are on the right track. Lets check what is happening now.
        $ConversionStatus = ($EncryptableVolume.GetConversionStatus()).ConversionStatus
	    Switch($ConversionStatus) {
            0 {
                # Bitlocker fully decrypted.
                # https://msdn.microsoft.com/en-us/library/windows/desktop/aa376433(v=vs.85).aspx
                # We should be safe to delete all Key Protectos now.
                $KeyProtectors = ($EncryptableVolume.GetKeyProtectors()).VolumeKeyProtectorID
                ForEach ($KeyProtector in $KeyProtectors) {  
                    $return = $EncryptableVolume.DeleteKeyProtector($KeyProtector)
                    if($return.ReturnValue -eq 0) {
                        LogMsg "Return Value: $($return.ReturnValue)`r`nSuccesfully deleted key protector $KeyProtector." 510
                        #Nothing else needs to be done.
                    } else {
                        LogMsg "Return Value: $($return.ReturnValue)`r`nFailed to deleted key protector $KeyProtector." 511
                    }
                }
            }   
            1 { 
                #Conversion status is Fully Encrypted: https://msdn.microsoft.com/en-us/library/windows/desktop/aa376433(v=vs.85).aspx
                $return = $EncryptableVolume.Decrypt() # This will begin the decryption process but return with a success result instantly.
                if($return.ReturnValue -eq 0) { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully began decryption process." 512
                    $state = $True
                } else {
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to begin decryption proccess." 513 -Type Error
                    $state = $False
                }
            }
            { ($_ -eq 2) -or ($_ -eq 4) } {
                #Conversion status is Encryption in progress or Encryption is paused.
                #In this state we want to begin to decrypt.
                $return = $EncryptableVolume.Decrypt() # This will begin the decryption process but return with a success result instantly.
                if($return.ReturnValue -eq 0) { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully enabled decryption." 514
                    $state = $True
                } else { 
                    LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to enable decryption." 515 -Type Error
                    $state = $False
                }
            }
            5 {
                #Decryption is currently paused. Lets Resume. 
                $return = $EncryptableVolume.ResumeConversion() # https://msdn.microsoft.com/en-us/library/windows/desktop/aa376473(v=vs.85).aspx
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
        #Protection status is Fully Encrypted: https://msdn.microsoft.com/en-us/library/windows/desktop/aa376448(v=vs.85).aspx
        $return = $EncryptableVolume.Decrypt() # This will begin the decryption process but return with a success result instantly.
        if($return.ReturnValue -eq 0) { 
            LogMsg "Return Value: $($return.ReturnValue)`r`nSuccessfully began decryption process." 512
            $state = $True
        } else {
            LogMsg "Return Value: $($return.ReturnValue)`r`nUnable to begin decryption proccess." 513 -Type Error
            $state = $False
        }
    }
    2 {
        #Protection status is unknown. Don't touch this with a 10ft barge pole.s
    }
}