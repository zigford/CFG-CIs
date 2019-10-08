$VerbosePreference = 'SilentlyContinue'
$logPath = "$env:WinDir\AppLog"
$logFile = "$logPath\$($MyInvocation.MyCommand).log"
#Start-Transcript $logFile
Write-Output "Logging to $logFile" | Out-File $logFile -Append

function SetShortcut {
    Param($ShortcutPath,$TargetPath)
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$ShortcutPath")
    $Shortcut.TargetPath = "$TargetPath"
    $Shortcut.Save()
}

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
        Write-Output "Shortcut target is blank. We will replace it with a new one" | Out-File $logFile -Append
        Write-Output "Removing Original Shortcut" | Out-File $logFile -Append
        Remove-Item -Path $ExistingShortcutPath -Force
        Write-Output "Setting new Shortcut" | Out-File $logFile -Append
        SetShortcut -ShortcutPath $ExistingShortcutPath -TargetPath "$env:WinDir\CCM\ClientUX\SCClient.exe"
    } else {
        Write-Output "Shortcut target path is not blank. No need to do anything" | Out-File $logFile -Append
    }
} Else {
    Write-Output "No existing Shortcut, creating a new one" | Out-File $logFile -Append
    SetShortcut -ShortcutPath $ExistingShortcutPath -TargetPath "$env:WinDir\CCM\ClientUX\SCClient.exe"
}
Write-Output "Exiting" | Out-File $logFile -Append
#Stop-Transcript