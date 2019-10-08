$InstallState = (Get-WmiObject -Query 'Select InstallState from Win32_OptionalFeature WHERE Name = "Microsoft-Windows-Subsystem-Linux"').InstallState
If ($InstallState -eq 1) {
    $True
}