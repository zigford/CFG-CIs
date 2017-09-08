#Compliance Check for Nvivo 10 SP5
$NewLicense = 'NVT10-LZ000-CCA2U-BM6VK-8WPDA'
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
    Write-Host "Updating XML file..`r`n"
    $XMLFile = "$InstallPath\ActivateUSC.xml"
    If (Test-Path -Path $XMLFile) {
        Set-Content -Path $XMLFile -Value $ActivateXML -Force
    } Else {
        New-Item -Path $XMLFile -ItemType File -Value $ActivateXML
    }
    $ProcUpdateLicense = Start-Process -FilePath nvivo.exe -ArgumentList "-i $NewLicense" -Wait -PassThru
    If ($ProcUpdateLicense.ExitCode -eq 0) {
        $ProcActivateLicense = Start-Process -FilePath nvivo.exe -ArgumentList '-a ActivateUSC.xml' -Wait -PassThru
        If ($ProcActivateLicense.ExitCode -eq 0) {
            Write-Host "Activation Success`r`n"
        } Else {
            Write-Host "Activation Failed, exit sadly`r`n"
            exit 1
        }
    } Else {
        Write-Host "Unable to update license`r`n"
        exit 1
    }
} Else {
    Write-Host "Nvivo exe not found`r`n"
    exit 1
}