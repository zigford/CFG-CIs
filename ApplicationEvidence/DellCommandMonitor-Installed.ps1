$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command \| Monitor'}
If ($ARPEntry) {
    Try {
        Get-WMIObject -NameSpace root\dcim\sysman -Class DCIM_BiosService -ErrorAction Stop | Out-Null
        "Installed"
    } Catch {
    }
}