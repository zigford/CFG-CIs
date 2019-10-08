$InstallState = (Get-WmiObject -Query 'Select InstallState from Win32_OptionalFeature WHERE Name = "Containers-DisposableClientVM"').InstallState
If ($InstallState -eq 1) {
    $True
}