Import-Module AppvClient
$PackageID = "de282145-3b9b-4904-8ce6-39eb38e1adf9"
$VersionID = "04d22b20-14f1-4b6a-bdf7-29726fecab6d"

If (Get-AppvVirtualProcess -Name Dropbox) {
    Stop-AppvClientPackage -PackageId $PackageID -VersionId $VersionID
    If ($? -eq $True) {
        Start-Sleep -Seconds 10
        $True
    } Else {
        $False
    }
} Else {
    $True
}
