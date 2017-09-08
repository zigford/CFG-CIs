$ErrorActionPreference = "SilentlyContinue"
Import-Module AppvClient
$PackageID = "51700d16-3c96-4ca7-b894-f62b9d9836f9"
$VersionID = "aa0d892f-87cc-42ca-a8e7-4c9645928a14"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Unpublish-AppvClientPackage -Global
Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Publish-AppvClientPackage -Global