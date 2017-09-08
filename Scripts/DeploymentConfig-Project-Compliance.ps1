Import-Module AppvClient
$PackageID = "15ef8a40-64a0-4d28-8e61-ce523b66a47c"
$VersionID = "461660b6-5e9b-422a-b8d1-11f88dee4107"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Project 2010.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}