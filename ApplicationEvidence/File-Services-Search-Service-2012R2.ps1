$InstallState = (Get-WmiObject -Query 'Select InstallState from Win32_OptionalFeature WHERE Name = "File-Services-Search-Service"').InstallState
If ($InstallState -eq 1) {
    $True
}