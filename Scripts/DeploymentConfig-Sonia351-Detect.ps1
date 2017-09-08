Import-Module AppvClient
$PackageID = "4fcd0002-2b3f-47df-bffa-2c1df503c2b5"
$VersionID = "1a623915-3591-42e6-b66b-1ee08b746f10"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID | Where-Object {$_.IsPublishedToUser}