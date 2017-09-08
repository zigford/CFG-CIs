Import-Module AppvClient
$PackageID = "13c488ae-94ac-4f63-b7ba-7c026e346fc5"
$VersionID = "0a7d8b97-17f5-4d25-86f2-75ca131ffafa"
$ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Dartfish\Dartfish Classroom Plus 6.9.136.lnk"

If (Test-Path -Path $ShortcutPath) {
    $True
} Else {
    $False
}