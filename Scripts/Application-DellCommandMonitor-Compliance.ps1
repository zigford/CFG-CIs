# Check if it's installed
$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command | Monitor'}
If (-Not $ARPEntry) {
    #  If the Add remove programs entry doesn't exist. The app state is compliant
    return $True
}
# After that, we know it's installed. Lets perform a WMI test to confirm the service is functional

Try {
    Get-WMIObject -NameSpace root\dcim\sysman -Class DCIM_BiosService -ErrorAction Stop | Out-Null
    # If we have gotten here without an exception. The service is compliant.
    $True
} Catch {
    # Assuming we have hit an exception, this means that we cannot attach to the service and the app needs to be repaired
    # As this is a compliance script. We will simply return non compliant
    $False
    # Start-Process -FilePath msiexec.exe -ArgumentList "/fam $($ARPEntry.PSChildName) /qn" -Wait -PassThru
}
