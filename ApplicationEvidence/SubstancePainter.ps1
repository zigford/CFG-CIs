Import-Module AppvClient
$PackageID = "bd05edab-bfdb-499f-94ac-6c36770eb138"
$VersionID = "d0bc751c-ae6a-4b6a-93d7-62e28aa6102e"

Get-AppVClientPackage -PackageID $PackageID -VersionID $VersionID
