Import-Module AppvClient
$PackageID = "86a69e07-1a65-4158-af5e-7c007a066938"
$VersionID = "3c4a5596-f005-45f9-92f7-2b6254e3c53f"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Chelsea Technologies\cView12\cView Report Viewer.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}