$BiosPassword = 'PasswordHere'
function Activate-TPM {
    [CmdLetBinding()]
    Param($BiosPassword)

    $BiosService = Get-WMIObject -Namespace root\dcim\sysman -Class DCIM_BiosService
    $Result = $BiosService.SetBIOSAttributes($null,$null,"Trusted Platform Module Activation","2",$BiosPassword)
    Switch ($Result.SetResult) {
       0 {Write-Verbose "TPM Activation Succesfull"} 
       Default {Write-Error "Failed to activate TPM"}
    }

}
