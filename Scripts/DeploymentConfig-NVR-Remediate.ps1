$ErrorActionPreference = "SilentlyContinue"
Import-Module AppvClient
$PackageID = "210138f2-688a-4fbc-b88d-38796f81fa66"
$VersionID = "4947f332-22ec-4d9e-9bc9-750deede791b"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Unpublish-AppvClientPackage -Global
Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Publish-AppvClientPackage -Global