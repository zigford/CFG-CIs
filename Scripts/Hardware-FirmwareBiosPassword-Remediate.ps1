#Set password here: $NewPassword = 'newpassword'

function Set-DellBiosPassword {
    [CmdLetBinding()]
    Param($NewPassword="",$OldPassword="")
    $Result = (Get-WmiObject -Namespace Root\DCIM\Sysman -Class DCIM_BiosService).SetBIOSAttributes($null,$null,"AdminPwd",$NewPassword,$OldPassword)
    Switch ($Result.SetResult) {
        0 {Write-Verbose "Succesfully set new bios setup password"}
        Default {Write-Error "Failed to set new bios password: Result $($Result.SetResult)"}
    }
}

Set-DellBiosPassword -NewPassword $NewPassword
