Import-Module AppvClient
$PackageID = "36c97f90-198f-45ce-b4bf-b527faa1da68"
$VersionID = "03bae852-3bea-40b9-9d29-04fc59119aa7"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID