$ErrorActionPreference = "SilentlyContinue"
Import-Module AppvClient
$PackageID = "13c488ae-94ac-4f63-b7ba-7c026e346fc5"
$VersionID = "0a7d8b97-17f5-4d25-86f2-75ca131ffafa"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Unpublish-AppvClientPackage -Global
Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID -All | Publish-AppvClientPackage -Global