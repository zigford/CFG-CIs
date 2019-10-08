Import-Module AppvClient
$PackageID = "6e07aa5b-a9f2-4562-b166-ac00398c6ed4"
$VersionID = "182664c2-8941-47ef-acd7-37dd19af051b"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\C-Motion\Visual3D v4.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}