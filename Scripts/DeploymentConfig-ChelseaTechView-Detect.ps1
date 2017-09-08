Import-Module AppvClient
$PackageID = "86a69e07-1a65-4158-af5e-7c007a066938"
$VersionID = "3c4a5596-f005-45f9-92f7-2b6254e3c53f"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID