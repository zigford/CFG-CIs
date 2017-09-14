$BiosPassword = 'PasswordHere'
function Get-DellBiosSetupPasswordState {
    [CmdLetBinding()]
    Param()
    $Query = 'Select * from DCIM_BiosPassword Where AttributeName = "AdminPwd"'
    (Get-WmiObject -Namespace root\dcim\sysman -Query $Query).IsSet
}

function Get-DellBiosBootPasswordState {
    [CmdLetBinding()]
    Param()
    $Query = 'Select * from DCIM_BiosPassword Where AttributeName = "SystemPwd"'
    (Get-WmiObject -Namespace root\dcim\sysman -Query $Query).IsSet
}

function Test-DellBiosSetupPassword {
    [CmdLetBinding()]
    Param($BiosPassword)

    Try {
        Set-DellBiosSetupPassword -NewPassword $BiosPassword -OldPassword $BiosPassword
        $True
    } Catch {
        $False
    }
}

function Set-DellBiosSetupPassword {
    [CmdLetBinding()]
    Param($NewPassword="",$OldPassword="")
    $Result = (Get-WmiObject -Namespace Root\DCIM\Sysman -Class DCIM_BiosService).SetBIOSAttributes($null,$null,"AdminPwd",$NewPassword,$OldPassword)
    Switch ($Result.SetResult) {
        0 {Write-Verbose "Succesfully set new bios setup password"}
        Default {Write-Error "Failed to set new bios password: Result $($Result.SetResult)"}
    }
}


Test-DellBiosSetupPassword -BiosPassword $BiosPassword
