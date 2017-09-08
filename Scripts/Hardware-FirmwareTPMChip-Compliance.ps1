$Global:logFile = "$env:WinDir\AppLog\Hardware-FirmwareTPMChip-Compliance.ps1.log"
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}
function Get-DellTPMStatus {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True
            )
        ]$ComputerName=$env:ComputerName
    )
    Begin {}
    Process {
        if ($ComputerName.ComputerName) {
            $ComputerName = $ComputerName.ComputerName
        }
        $DCIMNameSpace = Get-WmiObject -ComputerName $ComputerName -Namespace root -ClassName __NameSpace | Where-Object {$_.Name -eq 'DCIM'}
        if (-Not $DCIMNameSpace) {
            Write-Error "Dell Command | Monitor not installed" -ErrorAction SilentlyContinue
            break
        }

        $TPMSetting = Get-WmiObject -ComputerName $ComputerName -Namespace root\dcim\sysman -ClassName DCIM_BiosEnumeration | Where-Object {$_.AttributeName -eq 'Trusted Platform Module'}
        Switch ($TPMSetting.CurrentValue) {
            1 {$Enabled = $True}
            2 {$Enabled = $False}
            Default {$Enabled = $False}
        }
        [PSCustomObject]@{
            'ComputerName' = $ComputerName
            'TPMEnabled' = $Enabled
        }
    }
}

function Get-DellBootMode {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True
        )
        ]$ComputerName=$env:COMPUTERNAME
    )
    Begin{}
    Process {
        If ($ComputerName.ComputerName) {
            $ComputerName = $ComputerName.ComputerName
        }
        $DCIMNameSpace = Get-WmiObject -ComputerName $ComputerName -Namespace root -ClassName __NameSpace | Where-Object {$_.Name -eq 'DCIM'}
        If (-Not $DCIMNameSpace) {
            Write-Error "Dell Command | Monitor not installed" -ErrorAction SilentlyContinue
            break
        }
        $BootSetting = Get-WmiObject -ComputerName $ComputerName -NameSpace root\dcim\sysman -ClassName DCIM_BiosEnumeration | Where-Object {$_.AttributeName -eq 'Boot Mode'}
        Switch ($BootSetting.CurrentValue) {
            1 {$BootMode = 'BIOS'}
            2 {$BootMode = 'UEFI'}
            Default {'Unknown'}
        }
        [PSCustomObject]@{
            'ComputerName' = $ComputerName
            'BootMode' = $BootMode
        }
    }
}

If ((Get-DellBootMode).BootMode -eq 'UEFI') {
    logMsg "Boot mode is UEFI"
    If ((Get-DellTPMStatus).TPMEnabled) {
        logMsg "TPM is enabled"
        $True
    } Else {
        logMsg "TPM is disabled"
        $False
    }
} else {
    logMsg "Boot mode is not UEFI"
    $True
}