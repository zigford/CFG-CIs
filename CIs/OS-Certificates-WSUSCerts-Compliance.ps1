$CertificateSerial = '75efc07bd4cbb2a8423b77a448f2e810'
$Stores = 'trustedpublisher','root'
$CertUtil = "$env:SystemRoot\System32\certutil.exe"
$AssumeResult = $True

If ((Test-Path -Path $CertUtil) -eq $False) {
    return $False
}

ForEach ($Store in $Stores) {
    $CertInfo = (& $CertUtil -verifystore $Store)
    If (-Not ($CertInfo -match $CertificateSerial)) {
        $AssumeResult = $False
    }
}
$AssumeResult