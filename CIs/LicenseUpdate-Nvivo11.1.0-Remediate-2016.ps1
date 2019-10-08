Start-Transcript -Path $env:WinDir\AppLog\Nvivo11LicenseRemediate.log -Append -NoClobber

Write-Output "Compliance Check for Nvivo 11`r`n"
$NewLicense = 'NVT11-LZ000-BGA2U-HH6OR-MP62Y'
$ActivateXML = @'
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Activation>
  <Request>
    <FirstName>Jesse</FirstName>
    <LastName>Harris</LastName>
    <Email>AssetSystemsOfficer@usc.edu.aum</Email>
    <Phone>+61-754-594-692</Phone>
    <Fax></Fax>
    <JobTitle>Client Systems Analyst</JobTitle>
    <Sector>Higher Education</Sector>
    <Industry>Education</Industry>
    <Role>Application Packaging</Role>
    <Department>IT Services</Department>
    <Organization>University of the Sunshine Coast</Organization>
    <City>Sippy Downs</City>
    <Country>Australia</Country>
    <State>Queensland</State>
  </Request>
</Activation>
'@

$InstallPath = Get-ItemProperty -Path 'HKLM:\Software\QSR\NV\11' -Name 'Install Path' | Select-Object -ExpandProperty 'Install Path'
If (Test-Path $InstallPath\Nvivo.exe) {
    Set-Location -Path $InstallPath
    Write-Output "Updating XML file..`r`n"
    $XMLFile = "$InstallPath\ActivateUSC.xml"
    If (Test-Path -Path $XMLFile) {
        Set-Content -Path $XMLFile -Value $ActivateXML -Force
    } Else {
        New-Item -Path $XMLFile -ItemType File -Value $ActivateXML
    }
    $ProcUpdateLicense = Start-Process -FilePath nvivo.exe -ArgumentList "-e $NewLicense" -Wait -PassThru
    If ($ProcUpdateLicense.ExitCode -eq 0) {
        Write-Output "Successfully updated license with -i`r`n"
        $ProcActivateLicense = Start-Process -FilePath nvivo.exe -ArgumentList '-a ActivateUSC.xml' -Wait -PassThru
        If ($ProcActivateLicense.ExitCode -eq 0) {
            Write-Output "Activation Success`r`n"
        } Else {
            Write-Output "Activation Failed, exit sadly`r`n"
            exit 1
        }
    } Else {
        Write-Output "Unable to update license`r`n"
        exit 1
    }
} Else {
    Write-Output "Nvivo exe not found`r`n"
    exit 1
}
Stop-Transcript
