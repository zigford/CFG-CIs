Import-Module AppvClient
$PackageID = "e687e1ae-b373-41fb-b92c-a60fb9a77279"
$VersionID = "B6806585-0122-461A-A059-05121E968F5C"

Get-AppvClientPackage -PackageID $PackageID -VersionId $VersionID