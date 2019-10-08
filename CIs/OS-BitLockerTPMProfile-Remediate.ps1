[CmdLetBinding()]
Param($Set)

function Get-UEFIValidationProfile {
    [CmdLetBinding()]
    Param([Switch]$ListAll)
    $PolicyPath = 'HKLM:\Software\Policies\Microsoft\FVE\OSPlatformValidation_UEFI'
    Write-Verbose "Testing if UEFI Profile is configured"
    If (-Not (Test-Path -Path $PolicyPath -EA SilentlyContinue)) {
        Write-Verbose "Unable to find validation profile"
        break
    }
    For ($i=0; $i -le 23;$i++ ) {
        $PCR = Get-PCR $i
        If ($ListAll){
            $PCR
        } else {
            If ($PCR.Enabled) {
                $PCR
            }
        }
    }
}

function Get-PCR {
    [CmdLetBinding()]
    Param(
        [ValidateRange(0,23)]
        [int]$PCR
    )
    Begin {
        $PolicyPath = 'HKLM:\Software\Policies\Microsoft\FVE\OSPlatformValidation_UEFI'
    }
    Process {
        if ((Get-ItemPropertyValue -Path $PolicyPath -Name $PCR) -eq 0) {
            [PSCustomObject]@{
                'PCR' = $PCR
                'Enabled' = $False
            }
        } else {
            [PSCustomObject]@{
                'PCR' = $PCR
                'Enabled' = $True
            }
        }
    }
}

function Enable-PCR {
    [CmdLetBinding()]
    Param(
        [ValidateRange(0,23)]
        [int]$PCR
        )
    Begin {
        $PolicyPath = 'HKLM:\Software\Policies\Microsoft\FVE\OSPlatformValidation_UEFI'
    }
    Process {
        $CheckPCR = Get-PCR -PCR $PCR
        If ($CheckPCR.Enabled) {
            Write-Verbose "PCR $PCR already enabled"
            $CheckPCR
        } Else {
            Write-Verbose "Attempting to enable PCR $PCR"
            Set-ItemProperty -Path $PolicyPath -Name $PCR -Value 1 -Force
            $NewCheckPCR = Get-PCR -PCR $PCR
            If ($NewCheckPCR.Enabled) {
                Write-Verbose "Succefully set PCR $PCR to enabled"
                $NewCheckPCR
            } else {
                Write-Error "Failed to set PCR $PCR to enabled"
            }
        }
    }
}
function Disable-PCR {
    [CmdLetBinding()]
    Param(
        [ValidateRange(0,23)]
        [int]$PCR
        )
    Begin {
        $PolicyPath = 'HKLM:\Software\Policies\Microsoft\FVE\OSPlatformValidation_UEFI'
    }
    Process {
        $CheckPCR = Get-PCR -PCR $PCR
        If ($CheckPCR.Enabled -eq $False) {
            Write-Verbose "PCR $PCR already disabled"
            $CheckPCR
        } Else {
            Write-Verbose "Attempting to disable PCR $PCR"
            Set-ItemProperty -Path $PolicyPath -Name $PCR -Value 0 -Force
            $NewCheckPCR = Get-PCR -PCR $PCR
            If ($NewCheckPCR.Enabled -eq $False) {
                Write-Verbose "Succefully set PCR $PCR to disabled"
                $NewCheckPCR
            } else {
                Write-Error "Failed to set PCR $PCR to disabled"
            }
        }
    }
}

function Set-UEFIValidationProfile {
    [CmdLetBinding()]
    Param(
        [ValidateRange(0,23)]
        $PCRs
        )
    Begin {
        Write-Verbose "Testing $PCRs"
    }
    Process {
        Get-UEFIValidationProfile -ListAll | ForEach-Object {
            If ($_.PCR -in $PCRs) {
                Enable-PCR -PCR $_.PCR
            } Else {
                Disable-PCR -PCR $_.PCR
            }
        }
    }
}

function Get-PCRFromTPM {
    [CmdLetBinding()]
    Param()
    Begin {}
    Process {
        $EXEPath = "$env:SystemRoot\System32\manage-bde.exe"
        $Args = "-protectors -get $env:SystemDrive"
        $ManageBDEOutPut = Invoke-Expression "$EXEPath $Args"
        $PCRString = $ManageBDEOutPut | Select-String -Pattern '^\s.*PCR\sValidation\sProfile.*$' -Context 0,1
        $PCRs = $PCRString.Context.PostContext[0].TrimStart().Split(',') | ForEach-Object {
            [int]$_.Trim()
        }
    }
}
$ErrorActionPreference = 'Stop'

Suspend-BitLocker -MountPoint $env:SystemDrive
Set-UEFIValidationProfile -PCRs 7,11
Resume-BitLocker -MountPoint $env:SystemDrive