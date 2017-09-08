Import-Module AppvClient
$PackageID = "51c304ca-ea12-4837-a53f-fe8454ceabf8"
$VersionID = "1b8b0e6c-fb78-4115-9326-88cfe4e42a1e"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID