Import-Module ServerManager
$InstallState = Get-WindowsFeature -Name Search-Service
$InstallState.Installed