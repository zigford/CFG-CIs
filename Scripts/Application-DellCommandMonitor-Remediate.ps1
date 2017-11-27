$Global:logFile = "$env:WinDir\AppLog\Application-DellCommandMonitor-Remediate.ps1.log"
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}
# Get ARP Entry
$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command | Monitor'}
If (-Not $ARPEntry) {
    #  If the Add remove programs entry doesn't exist. This kinda can't happen.
    logMsg "Unable to find Dell Command | Monitor ARP Entry. Exiting with an error"
    Write-Error "Unable to find Dell Command | Monitor ARP Entry" -ErrorAction Stop
}
# After that, we know it's installed. Lets repair the MSI

logMsg "Starting repair process. Command:"
logMsg "msiexec.exe /fam $($ARPEntry.PSChildName) /qn REBOOT=REALLYSUPPRESS"
$Result = Start-Process -FilePath msiexec.exe -ArgumentList "/fam $($ARPEntry.PSChildName) /qn REBOOT=REALLYSUPPRESS" -Wait -PassThru
logMsg "ExitCode: $($Result.ExitCode)"