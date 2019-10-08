Import-Module AppvClient
$PackageID = "51c304ca-ea12-4837-a53f-fe8454ceabf8"
$VersionID = "1b8b0e6c-fb78-4115-9326-88cfe4e42a1e"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Programmer's Notepad\Programmer's Notepad 2.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}