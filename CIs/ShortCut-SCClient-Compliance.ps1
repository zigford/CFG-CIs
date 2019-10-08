#Lets see if we are upgraded or wipe and reload:
$VerbosePreference = 'SilentlyContinue'
$logPath = "$env:WinDir\AppLog"
$logFile = "$logPath\$($MyInvocation.MyCommand).log"
#Start-Transcript $logFile
Write-Output "Logging to $logFile" | Out-File $logFile -Append
function Test-UpgradedComputer {
    [CmdLetBinding()]
    Param()
    $TattooPath = 'HKLM:\Software\USC\MOETattoo'
    If (Test-Path -Path $TattooPath) {
        Write-Output "$TattooPath exists. Keep testing" | Out-File $logFile -Append
        #Test if the Build TS Name and version match an upgrade
        $BuildTSName = Get-ItemProperty -Path $TattooPath -Name "Build TS Name" -ErrorAction SilentlyContinue
        If ($BuildTSName) {
            Write-Output "Build TS Name exists in registry" | Out-File $logFile -Append
            #$BuildTSName
            If ($BuildTSName."Build TS name" -match '^Upgrade from Windows 7.*$') {
                Write-Output "Build name matches upgrade regex. This is an upgraded machine. Returning True to upgrade test." | Out-File $logFile -Append
                #Stop-Transcript
                return $true
            } Else {
                Write-Output "Build name does not match regex, not an upgraded machine" | Out-File $logFile -Append
            }
        } Else {
            Write-Output "Build TS Name does not exist in registry. Probably a wipe and reload" | Out-File $logFile -Append
        }
    } Else {
        Write-Output "Tattoo path does not exist. Probably a wipe and reload" | Out-File $logFile -Append
    }
    #Stop-Transcript
    return $False
}


function Test-FaultyShortcut {
    [CmdLetBinding()]
    Param()
    
    function GetShortcutTarget {
        Param($ShortCutPath)
        $ShellObject = New-Object -ComObject "Wscript.Shell"
        $Shortcut = $ShellObject.CreateShortcut($ShortCutPath)
        $Shortcut.targetpath
    }

    Write-Output "Testing for existence Software Center Shortcut" | Out-File $logFile -Append
    $ExistingShortcutPath = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk"
    If (Test-Path -Path $ExistingShortcutPath) {
        Write-Output "Found Existing Shortcut" | Out-File $logFile -Append
        If (-Not (GetShortcutTarget $ExistingShortcutPath)) {
            Write-Output "Shortcut target is blank. Returning true because shortcut is faulty" | Out-File $logFile -Append
            return $True
        } Else {
            Write-Output "Shortcut is pointing to a real targetpath" | Out-File $logFile -Append
        }
    } Else {
        Write-Output "Shortcut does not exist. Faulty" | Out-File $logFile -Append
        return $True
    }
    Write-Output "Everything checks out, not faulty returning False for faulty shortcut test" | Out-File $logFile -Append
    return $False
}

If ((Test-UpgradedComputer) -and (Test-FaultyShortcut)) {
    Write-Output "SCClient shortcut not compliant, return False" | Out-File $logFile -Append
    #Stop-Transcript
    return $False
} Else {
    Write-Output "SCClient shortcut compliant, return True" | Out-File $logFile -Append
    #Stop-Transcript
    return $True
}