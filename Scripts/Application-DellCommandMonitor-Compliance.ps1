# Check if it's installed
$Global:logFile = "$env:WinDir\AppLog\Application-DellCommandMonitor-Compliance.ps1.log"
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}

$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command | Monitor'}
If (-Not $ARPEntry) {
    #  If the Add remove programs entry doesn't exist. The app state is compliant
    return $True
    logMsg "Dell Command - Monitor does not have an ARP entry. Compliant"
} else {
    # After that, we know it's installed. Lets perform a WMI test to confirm the service is functional
    logMsg "Attempting to query WMI to see if Dell Command is functional"
    Try {
        Get-WMIObject -NameSpace root\dcim\sysman -Class DCIM_BiosService -ErrorAction Stop | Out-Null
        # If we have gotten here without an exception. The service is compliant.
        logMsg "Succesfully queried the DCIM\Sysman DCIM_BiosService. Returning True"
        return $True
    } Catch {
        # Assuming we have hit an exception, this means that we cannot attach to the service and the app needs to be repaired
        # As this is a compliance script. We will simply return non compliant
        logMsg "Failed to query the DCIM\Sysman DCIM_BiosService. Returning False"
        return $False
        # Start-Process -FilePath msiexec.exe -ArgumentList "/fam $($ARPEntry.PSChildName) /qn" -Wait -PassThru
    }
}