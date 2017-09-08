Start-Transcript -Path $env:WinDir\AppLog\NvivoLicenseRemediate.log -Append -NoClobber

Write-Output "Compliance Check for Nvivo 10 SP6`r`n"
$NewLicense = 'NVT10-LZ000-BFA2U-HA6UC-UBP23'
$ActivateXML = @'
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<Activation>
<Request>
<FirstName>Jesse</FirstName>
<LastName>Harris</LastName>
<Email>AssetSystemsOfficer@usc.edu.au</Email>
<Organization>University of the Sunshine Coast</Organization>
<Department>IT Services</Department>
<AddressLine1>90 Sippy Downs Drive</AddressLine1>
<AddressLine2></AddressLine2>
<City>Sippy Downs</City>
<State>QLD</State>
<Country>Australia</Country>
<Zipcode>4556</Zipcode>
<Fax></Fax>
<Industry>Education</Industry>
<Role>IT Services</Role>
<JobTitle>Asset Systems Officer</JobTitle>
<Phone>0754594800</Phone>
</Request>
</Activation>
'@

$InstallPath = Get-ItemProperty -Path 'HKLM:\Software\QSR\NV\10' -Name 'Install Path' | Select-Object -ExpandProperty 'Install Path'
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
