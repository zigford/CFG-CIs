# Get ARP Entry
$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command | Monitor'}
If (-Not $ARPEntry) {
    #  If the Add remove programs entry doesn't exist. This kinda can't happen.
    Write-Error "Unable to find Dell Command | Monitor ARP Entry" -ErrorAction Stop
}
# After that, we know it's installed. Lets repair the MSI

$Result = Start-Process -FilePath msiexec.exe -ArgumentList "/fam $($ARPEntry.PSChildName) /qn" -Wait -PassThru
Write-Verbose "ExitCode: $($Resule.ExitCode)"
