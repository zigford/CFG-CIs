Import-Module AppvClient
$PackageID = "210138f2-688a-4fbc-b88d-38796f81fa66"
$VersionID = "4947f332-22ec-4d9e-9bc9-750deede791b"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Control Center.lnk","C:\ProgramData\Microsoft\Windows\Start Menu\Control Center Client.lnk"
$ExitCode = $True
ForEach ($ShortCut in $ShortcutPath) {
    If (-Not (Test-Path -Path $Shortcut)) {
        $ExitCode = $False
    }
}
$ExitCode