# Test if setting exists:
$Key = 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate'
$ValueName = 'DoNotConnectToWindowsUpdateInternetLocations'

if ((Get-ItemProperty -Path $Key).PSObject.Members | Where-Object { $_.Name -eq $ValueName }) {
    # Value exists, check if it is 0
    If ((Get-ItemPropertyValue -Path $Key -Name $ValueName) -ne 0) {
        return "False"
    }
}

return "True"