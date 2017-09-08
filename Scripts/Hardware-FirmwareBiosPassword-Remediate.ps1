$BiosPassword = 'f1sh'

function Set-DellBiosPassword {
    [CmdLetBinding()]
    Param($BiosPassword)
    (Get-WmiObject -Namespace Root\DCIM\Sysman -Class DCIM_BiosService).SetBIOSAttributes($null,$null,"AdminPwd",$BiosPassword)
}

Set-DellBiosPassword -BiosPassword $BiosPassword