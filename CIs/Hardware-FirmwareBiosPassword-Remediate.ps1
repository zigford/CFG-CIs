#Set password here: $NewPassword = 'newpassword'

function Set-DellBiosPassword {
    [CmdLetBinding()]
    Param($NewPassword="",$OldPassword="")
    Try {
        $Service = Get-WmiObject -Namespace Root\DCIM\Sysman -Class DCIM_BiosService -ErrorAction Stop
    } Catch {
        Write-Error "Unable to attach to DCIM_BiosService: $($_.Exception.Message)" -ErrorAction Stop 
    }
    If ($Service) {
        $Result = $Service.SetBIOSAttributes($null,$null,"AdminPwd",$NewPassword,$OldPassword)
    }
    If ($Result) {
        $Result.SetResult | ForEach-Object {
            if ($_ -eq 0 ) {
                Write-Verbose "Succesfully set new bios setup password"
            } Else {
                Write-Error "Failed to set new bios password: Result $($Result.SetResult)" -ErrorAction Stop
            }
        } 
    } else {
        Write-Error "Failed to set new bios password: Result $($Result.SetResult)" -ErrorAction Stop
    }
}

Set-DellBiosPassword -NewPassword $NewPassword
