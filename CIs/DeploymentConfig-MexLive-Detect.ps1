Import-Module AppvClient
$PackageID = "e650d790-71f8-4082-9a40-701fffcbdbae"
$VersionID = "ee6880d9-15bc-4a8a-bd60-7540777092c4"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID