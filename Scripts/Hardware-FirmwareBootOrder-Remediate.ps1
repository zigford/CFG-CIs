[CmdLetBinding()]
Param($Run)
$BiosPassword = 'PasswordHere'

function Get-CurrentBootMode {
    [CmdLetBinding()]
    Param()
    Begin{}
    Process {
        Get-WmiObject -Namespace root\dcim\sysman -Class DCIM_ElementSettingData | ForEach-Object {
            if ($_.IsCurrent -eq 0) {
                'BIOS'
            } ElseIf ($_.IsCurrent -eq 1) {
                If ($_.SettingData -match 'DCIM:BootConfigSetting:Next:2') {
                    'UEFI'
                } else {
                    'BIOS'
                } 
            }
        }
    }
}

function Get-BootOrderObject {
    [CmdLetBinding()]
    Param(
        [ValidateSet(
            'UEFI',
            'BIOS'
        )]
        [String]$BootOrderType
    )
    Begin {}
    Process {
        $OrderedComponent = Get-WmiObject -namespace root\dcim\sysman -Class dcim_orderedcomponent 
        Switch ($BootOrderType) {
            'UEFI' {$OrderedComponent | Where-Object {$_.partcomponent -match 'BootListType-2'} }
            'BIOS' {$OrderedComponent | Where-Object {$_.partcomponent -match 'BootListType-1'} }
        }
    }
}

function Get-UEFIBootOrder {
    [CmdLetBinding()]
    Param()
    Begin {
        if (-Not (Get-BootOrderObject -BootOrderType UEFI)) {
            Write-Verbose "No UEFI Boot list configured"
            break
        } 
    }
    Process {
        $CurrentBootOrder = Get-BootOrderObject -BootOrderType UEFI | ForEach-Object {
            $PartComponent = $_.PartComponent
            $PartComponentMatch = $PartComponent.Replace('/','\\')
            $Query = "Select * from DCIM_BootSourceSetting Where __PATH = '" + $PartComponentMatch + "'"
            [PSCustomObject]@{
                'AssignedSequence' = $_.AssignedSequence
                'BiosBootString' = (Get-WmiObject -Namespace root\dcim\sysman -query $Query).BiosBootString
                'PartComponent' = $PartComponent
            }
        }
        $CurrentBootOrder
    }
}

function New-UEFIBootOrder {
    [CmdLetBinding()]
    Param(
        [ValidateSet(
            'Windows Boot Manager',
            'Onboard NIC(IPV4)',
            'Onboard NIC(IPV6)',
            'USB NIC(IPV4)',
            'USB NIC(IPV6)'
            )]
        [string[]]$Order
        )
    Begin {}
    Process {
        ForEach ($BootItem in $Order) {
            Get-UEFIBootOrder | Where-Object {$_.BiosBootString -eq $BootItem}
        }
        
    }
}

function Get-BootConfigObject {
    [CmdLetBinding()]
    Param(
        [ValidateSet(
            'UEFI',
            'BIOS'
        )]$BootConfigType
    )
    Process {
        $cbo = Get-WmiObject -namespace root\dcim\sysman -class dcim_bootconfigsetting
        Switch ($BootConfigType) {
            'UEFI' { $cbo | Where-Object { $_.InstanceID -eq 'DCIM:BootConfigSetting:Next:2' }}
            'BIOS'  { $cbo | Where-Object { $_.InstanceID -eq 'DCIM:BootConfigSetting:Next:1' }}
        }
    }
}

function Set-UEFIBootOrder {
    [CmdLetBinding()]
    Param(
        [ValidateScript(
            {
                if ($_.PartComponent) {
                    $True
                } Else {
                    Throw "Not a valid boot order"
                }
            }
        )]$BootOrder,
        [string]$BiosPassword,
        [switch]$SuspendBitlocker
    )
    Begin {
        if (-Not (Get-BootOrderObject -BootOrderType UEFI)) {
            Write-Verbose "No UEFI Boot list configured"
            break
        } 
    }
    Process {
        $BootOrderArray = $BootOrder | ForEach-Object {$_.PartComponent}
        If ($SuspendBitlocker) {
            $Bitlocker = Get-BitLockerVolume -MountPoint $env:SystemDrive
            If ($Bitlocker.ProtectionStatus.ToString() -eq 'On') {
                Write-Verbose 'Suspending Bitlocker'
                Suspend-BitLocker -MountPoint $env:SystemDrive -ErrorAction Stop | Out-Null
                Write-Verbose 'Bitlocker Suspended'
            } Else {
                Write-Verbose 'Bitlocker protections already disabled'
            }
        }
        Write-Verbose 'Setting new boot order'
        $Result = (Get-BootConfigObject -BootConfigType UEFI).changebootorder($BootOrderArray, $BiosPassword)
        If ($Result.ReturnValue -eq 0) {
            Write-Verbose 'Succesfully set new boot order'
            Get-UEFIBootOrder
        } else {
            Write-Error "Failed to set new boot order"
        }
    }
}

If ((Get-CurrentBootMode) -eq 'UEFI') {
    # We are running a UEFI boot mode.
    If (Get-UEFIBootOrder | Where-Object { $_.BiosBootString -ne 'Windows Boot Manager' -and $_.AssignedSequence -ne 0 }) {
        #Boot devices other than 'Windows Boot Manager' are not disabled (AssignedSequence = 0)
        #In the next command, we are setting a new boot order with a single entry of 'Windows Boot Manager' This will effectivly disable other boot devices by assigning them an AssignedSequence of 0
        Set-UEFIBootOrder -BiosPassword $BiosPassword -BootOrder (New-UEFIBootOrder -Order 'Windows Boot Manager') -SuspendBitlocker
    }
}
