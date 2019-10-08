$InstallState = (Get-WmiObject -Query 'Select InstallState from Win32_OptionalFeature WHERE Name = "Microsoft-Windows-GroupPolicy-ServerAdminTools-Update"').InstallState
If ($InstallState -eq 1) {
    $True
}