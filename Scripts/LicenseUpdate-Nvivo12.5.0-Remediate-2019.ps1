Param($Blah)
Start-Transcript -Path $env:WinDir\AppLog\Nvivo12LicenseRemediate.log -Append -NoClobber

Write-Output "Compliance Check for Nvivo 12`r`n"
$NewLicense = 'NVT12-LZ000-00000-00000-00000'
$LicensePath = 'HKLM:\Software\QSR\NV\12'
$ShortNewLicense = -join $NewLicense.ToCharArray()[0..22]

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

$InstallPath = Get-ItemProperty -Path 'HKLM:\Software\QSR\NV\12' `
    -Name 'Install Path' |
    Select-Object -ExpandProperty 'Install Path'

function Activate-NVivo {

    $ProcActivateLicense = Start-Process -FilePath nvivo.exe `
        -ArgumentList "-i $NewLicense -a ActivateUSC.xml" `
        -Wait -PassThru

    If ($ProcActivateLicense.ExitCode -eq 0) {
        Write-Output "Activation Success`r`n"
        # mark the reg
        If (-Not (Test-Path -Path $LicensePath)) {
            Write-Output "License path doesn't exist`r`n"
            Write-Output "Activation Failed, exit sadly`r`n"
            exit 1
        } else {
            $CurrentLicense = Get-ChildItem -Path $LicensePath |
                Select -ExpandProperty Property
            If ($ShortNewLicense -in $CurrentLicense) {
                Write-Output "Activation added license to key" 
            } else {
                Write-Output "License not added to key"
                Write-Output "Manually adding"
                Set-ItemProperty -Path 'HKLM:\Software\QSR\NV\12\License' `
                    -Name $ShortNewLicense -Value ''
            }
        }
    } else {
        Write-Output ("Exit Code: {0}`r`nActivation Failed, exit sadly`r`n" `
                -f $ProcActivateLicense.ExitCode)
        exit 1
    }
}

If (Test-Path $InstallPath\Nvivo.exe) {
    Set-Location -Path $InstallPath
    Write-Output "Updating XML file..`r`n"
    $XMLFile = "$InstallPath\ActivateUSC.xml"

    If (Test-Path -Path $XMLFile) {
        Set-Content -Path $XMLFile -Value $ActivateXML -Force
    } Else {
        New-Item -Path $XMLFile -ItemType File -Value $ActivateXML
    }

    While (Get-Process nvivo -EA SilentlyContinue) {
        Write-Output "Waiting for nvivo to exit`r`n"
        Start-Sleep -Seconds 30
    }

    $ProcDeactivate = Start-Process -FilePath nvivo.exe `
        -ArgumentList "-deactivate" -Wait -PassThru

    If ($ProcDeactivate.ExitCode -eq 0) {
        Write-Output "Successfully deactivated license`r`n"
        Activate-NVivo
    } else {
        Write-Output "Deactivation Failed`r`n"
        Activate-NVivo
    }

} Else {
    Write-Output "Nvivo exe not found`r`n"
    exit 1
}

Stop-Transcript
