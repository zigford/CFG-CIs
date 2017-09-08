$logPath = "$env:windir\AppLog"
$logFile = "$logPath\$($MyInvocation.MyCommand.Name).log"
$VerbosePreference = 'Continue'
Start-Transcript -Path $logFile
function Repair-Repository {
    [CmdLetBinding()]
    Param([switch]$Force)
    $Service = Get-Service -Name Winmgmt
    If ($Service.Status -eq 'Running') {
        Write-Verbose "Stopping Winmgmt service"
        $c = [int]1
        While ((Get-Service -Name Winmgmt) -ne 'Stopped' -and $c -lt 11) {
            $c++
            $Service | Stop-Service -Force
            Write-Verbose "Stopping service: attempt $c of 11"
        }
        if ((Get-Service Winmgmt).Status -ne 'Stopped') {
            Write-Verbose "Failed to stop service. Aborting"
            return $False
        }
    }
    $Service | Set-Service -StartupType Disabled
    If ($Force) {
        $Archs = 'Syswow64','System32'
        ForEach ($Arch in $Archs) {
            $wbem = "$env:WinDir\$Arch\wbem"
            $repo = "$wbem\Repository"
            If (Test-Path -Path $repo -EA SilentlyContinue) {
                $RandomName = Get-Random
                Write-Verbose "Renaming repository to Repo.$RandomName"
                If (-Not (Rename-Item $repo -NewName "Repo.$(Get-Random)" -Force -PassThru)) {
                    Write-Verbose "Unable to rename repository. Aborting"
                    return $False
                }
            }
            Set-Location $wbem
            Get-ChildItem -Filter *.dll | ForEach-Object {
                Write-Verbose "Registering $($_.Name)"
                Invoke-Expression "$($env:Windir)\$Arch\regsvr32.exe /s $($_.FullName)" | Out-Null
                Write-Verbose "Returned exit code $LastExitCode"
            }
        }
        #Recompile all mif and mofs
        $RecompileMofs = $True
    } else {
        $WinMgmt = "$($env:WinDir)\System32\wbem\WinMgmt.exe"
        Write-Verbose "Resetting Repository"
        $ResetOutput = Invoke-Expression "$WinMgmt /ResetRepository"
        if ($ResetOutput -eq 'WMI repository has been reset') {
            Write-Verbose "Non success output string:"
            Write-Verbose "$ResetOutput" 
            return $False
        }
    }
    $Service | Set-Service -StartupType Automatic
    Write-Verbose "Restarting service"
    If ($Service | Start-Service -PassThru) {
        Write-Verbose "Starting dependent services."
        $Service.DependentServices | Where-Object {$_.Status -eq 'Running'} | Start-Service
        If ($RecompileMofs) {
            Write-Verbose "Service online, recompiling mofs"
            ForEach ($wbem in "$env:WinDir\Syswow64\wbem","$env:WinDir\System32\wbem") {
                Get-ChildItem -Path $wbem -Include '*.mof','*.mfl' -Recurse | ForEach-Object {
                    Write-Verbose "Compiling $($_.FullName)"
                    Invoke-Expression "$wbem\mofcomp.exe ""$($_.FullName)""" | Out-Null
                    Write-Verbose "Returned exit code $LastExitCode"
                }
            }
        }    
        Write-Verbose "Returning True"
        return $True
    } else {
        Write-Verbose "Service failed to start"
        Write-Verbose "Returning False"
        return $False
    }

} 

Write-Verbose "Logging to $LogFile"

#Attempt to reset repository safely
If ((Repair-Repository) -ne $True) {
    #Force reset it
    Write-Verbose "Safe reset failed, attempting brute force method"
    If ((Repair-Repository -Force) -ne $True) {
        Write-Verbose "Manual WMI reset failed"
    } else {
        Write-Verbose "Manual WMI reset succeeded"
    }
} else {
    Write-Verbose "Succefully reset WMI Repository"
}

Stop-Transcript