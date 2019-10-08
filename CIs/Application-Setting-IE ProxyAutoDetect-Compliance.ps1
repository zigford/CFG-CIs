$ProxySetting = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections' -Name DefaultConnectionSettings).DefaultConnectionSettings
If ($ProxySetting[8] -eq 1) {
    $True
} Else {
    $False
}