#Double check we are not overwriting a prepaired TPM
If ((Get-TPM).TpmReady -eq $False) {
    $Result = Initialize-TPM
        if ($Result.ClearRequired) {
            Write-Error ""
        }
}
