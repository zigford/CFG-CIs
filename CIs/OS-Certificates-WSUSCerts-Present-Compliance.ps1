$CertificateSerial = '12854aecced4ebbf47148aad2c9e685a'
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