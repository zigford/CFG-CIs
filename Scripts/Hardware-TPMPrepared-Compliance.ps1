$TPMObject = Get-TPM
If ($TPMObject.TpmPresent -ne $True) {
    Write-Error "TPM is not present"
}
If ($TPMObject.TpmReady -ne $True) {
    return $False
} else {
    return $True
}
