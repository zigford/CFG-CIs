# Check if ProjectProXVol is installed

$ClickToRunProperties = Get-ItemProperty -Path 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration' -ErrorAction SilentlyContinue

If ($ClickToRunProperties) {
    # Click to run is installed
    If ($ClickToRunProperties.ProductReleaseIds -match 'ProjectProXVolume') {
        # In this case, ProjectProXVolume is installed. But we should check if it is the x86 version before returning compliant
        If ($ClickToRunProperties.Platform -eq 'x86') {
            Write-Output 'True'
        }
    }
}