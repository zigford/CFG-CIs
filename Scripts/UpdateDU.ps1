#	Remove Quicktime Preferences
#
#	Set Error Handling
function LogInfo {
Param($Message,$Component,$Context=$Env:Username,$ProcessID,$LogFile)
    If (-Not (Get-Variable -Name LineNumber)) {
        New-Variable -Name LineNumber -Value 0 -Scope Global
    }
    Set-Variable -Name LineNumber -Value ($LineNumber + 1) -Scope Global
    $timeStamp = "$(get-date -Format 'HH:mm:ss').297-600"
    $dateStamp = get-date -Format 'MM-dd-yyyy'
    $LogLine='<![LOG[' + $Message + ']LOG]!><time="' + $timeStamp + '" date="' + $dateStamp + '" component="' + $Component + '" context="' + $Context + '" type="1" thread="' + $ProcessID + '" file="' + $LogFile + ':' + $LineNumber + '">'
    $LogLine | Out-File -FilePath $LogFile -Append -Encoding utf8
}
$ErrorActionPreference = "SilentlyContinue"
$LogFile = 	"C:\Windows\AppLog\UpdateDefaultProfile.Log"
$Scripts =	Split-Path $Myinvocation.Mycommand.Path
$Me =		"RemoveQuicktimePreferences"
#

$TaskDesc = "Remove Quicktime Preferences"
$LoadReg = Start-Process -FilePath C:\Windows\System32\reg.exe -ArgumentList 'load "HKLM\DU" "C:\Users\Default User\NTUSER.DAT"' -PassThru -Wait
LogInfo -Message "Loading default profile for $TaskDesc exit code $($LoadReg.ExitCode)" -Component DefaultUserEngine -ProcessID $LoadReg.Id -LogFile $LogFile
If ($LoadReg.ExitCode -ne 0) {
    exit $LoadReg.ExitCode
}
Remove-Item -Path 'HKLM:\DU\Software\Apple Computer, Inc.\QuickTime\LocalUserPreferences' -Force
[gc]::Collect()
If ($? -eq $False) {
    $RegRemove = 1
} Else {
    $RegRemove = 0
}
LogInfo -Message "Running $TaskDesc exit code $RegRemove" -Component DefaultUserEngine -ProcessID $PID  -LogFile $LogFile
$UnloadReg = Start-process -FilePath C:\Windows\System32\reg.exe -ArgumentList 'unload "HKLM\DU"' -PassThru -Wait
LogInfo -Message "Unloading default profile for $TaskDesc exit code $($UnloadReg.ExitCode)" -Component DefaultUserEngine -ProcessID $UnloadReg.Id -LogFile $LogFile
If ($UnloadReg.ExitCode -ne 0) {
    exit $UnloadReg.ExitCode
}