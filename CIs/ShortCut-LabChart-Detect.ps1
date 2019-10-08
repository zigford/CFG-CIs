Import-Module AppvClient
$PackageID = "649d0ee1-00bf-4ef9-8e02-7ad82eb9d000"
$VersionID = "767774b5-b172-4751-a41e-95e186b8878b"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID