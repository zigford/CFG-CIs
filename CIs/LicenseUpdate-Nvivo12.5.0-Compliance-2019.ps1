#Compliance Check for Nvivo 12
$NewLicense = 'NVT12-LZ000-00000-00000'
$LicensePath = 'HKLM:\Software\QSR\NV\12'
If (-Not (Test-Path -Path $LicensePath)) {
    exit 1
} Else {
    $CurrentLicense = Get-ChildItem -Path $LicensePath | Select -ExpandProperty Property
    If ($NewLicense -in $CurrentLicense) {
        $True
    } Else {
        $False
    }
}