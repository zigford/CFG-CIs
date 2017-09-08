Import-Module AppvClient
$PackageID = "51700d16-3c96-4ca7-b894-f62b9d9836f9"
$VersionID = "aa0d892f-87cc-42ca-a8e7-4c9645928a14"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office\Microsoft Publisher 2010.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}