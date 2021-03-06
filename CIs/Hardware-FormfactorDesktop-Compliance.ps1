function Get-HardwareType {
    Try {
        $CompSys = Get-CimInstance -ClassName Win32_ComputerSystem -Property PCSystemType | Select-Object -ExpandProperty PCSystemType
        Switch ($CompSys) {
            1 {'Desktop'}
            2 {'Laptop'}
            3 {'Workstation'}
            4 {'Enterprise Server'}
            5 {'SOHO Server'}
            6 {'Applicance PC'}
            7 {'Performance Server'}
            Default {'Unspecified'}
        }
    } Catch {
        throw 'Cant return ciminstance'
    }
}

function Get-InstalledProduct {
    [CmdLetBinding()]
    Param($MSICode='{91E79414-DB41-4030-9A13-E133EE30F1D5}')
    
    $Installed = $False
    $Hives = 'HKLM:\Software','HKLM:\Software\Wow6432Node'
    $Hives | ForEach-Object {
        $UninstallPath = "$_\Microsoft\Windows\CurrentVersion\Uninstall"
        if (Test-Path -Path "$UninstallPath\$MSICode") {
            $Installed = $True
        }
    }
    return $Installed
}

If ((Get-HardwareType) -ne 'Laptop' -and (Get-InstalledProduct)) {
    $True
} else {
    $False
}