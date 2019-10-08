$ErrorActionPreference = "SilentlyContinue"
Import-Module AppvClient
$PackageID = "15ef8a40-64a0-4d28-8e61-ce523b66a47c"
$VersionID = "461660b6-5e9b-422a-b8d1-11f88dee4107"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Unpublish-AppvClientPackage -Global
Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Publish-AppvClientPackage -Global