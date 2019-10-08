#Compliance Check for Nvivo 11
$NewLicense = 'NVT11-LZ000-BGA2U-HH6OR'
$LicensePath = 'HKLM:\Software\QSR\NV\11'
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