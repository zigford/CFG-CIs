$RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$Property = 'DefaultConnectionSettings'
$ProxySetting = (Get-ItemProperty -Path $RegPath).$Property
$ProxySetting[8] = 01
Set-ItemProperty -Path $RegPath -Name $Property -Value $ProxySetting