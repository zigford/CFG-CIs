try {
    $tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
    $logPath = $tsenv.Value("LogPath")
} catch {
    Write-Host "This script is not running in a task sequence"
    $logPath = $env:windir + "\temp"
}

$logFile = "$logPath\$($myInvocation.MyCommand).log"

Start-Transcript $logFile
Write-Host "Logging to $logFile"

# List of Applications that will be removed
$AppsList = "Microsoft.3DBuilder","Microsoft.BingFinance","Microsoft.BingNews","Microsoft.BingSports","Microsoft.BingWeather","Microsoft.Getstarted","Microsoft.Messaging","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.OneConnect","Microsoft.People","Microsoft.SkypeApp","Microsoft.Windows.Photos","Microsoft.WindowsAlarms","microsoft.windowscommunicationsapps","Microsoft.WindowsFeedbackHub","Microsoft.WindowsMaps","Microsoft.WindowsPhone","Microsoft.XboxApp","Microsoft.XboxIdentityProvider","Microsoft.ZuneMusic","Microsoft.ZuneVideo"

ForEach ($App in $AppsList) {
    $Packages = Get-AppxPackage -AllUsers | Where-Object {$_.Name -eq $App}
    if ($Packages -ne $null) {
        Write-Host "Removing Appx Package: $App"
        foreach ($Package in $Packages) {
            Remove-AppxPackage -package $Package.PackageFullName
        }
    } else {
        Write-Host "Unable to find package: $App"
    }

    $ProvisionedPackage = Get-AppxProvisionedPackage -online | Where-Object {$_.displayName -eq $App}
    if ($ProvisionedPackage -ne $null) {
        Write-Host "Removing Appx Provisioned Package: $App"
        remove-AppxProvisionedPackage -online -packagename $ProvisionedPackage.PackageName
    } else {
        Write-Host "Unable to find provisioned package: $App"
    }

}

# Stop logging
Stop-Transcript