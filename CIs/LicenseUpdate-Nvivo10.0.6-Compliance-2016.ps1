#Compliance Check for Nvivo 10 SP5
$NewLicense = 'NVT10-LZ000-BFA2U-HA6UC'
$LicensePath = 'HKLM:\Software\QSR\NV\10'
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