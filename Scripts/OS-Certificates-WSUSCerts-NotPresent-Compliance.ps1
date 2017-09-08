$CertificateSerial = '75efc07bd4cbb2a8423b77a448f2e810'
$Stores = 'trustedpublisher','root'
$CertUtil = "$env:SystemRoot\System32\certutil.exe"
$AssumeResult = $False

If ((Test-Path -Path $CertUtil) -eq $False) {
    return $True
}

ForEach ($Store in $Stores) {
    $CertInfo = (& $CertUtil -verifystore $Store)
    If ($CertInfo -match $CertificateSerial) {
        $AssumeResult = $True
    }
}
$AssumeResult