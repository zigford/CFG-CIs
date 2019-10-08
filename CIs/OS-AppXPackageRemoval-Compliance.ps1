$Compliance = $True
$AppsList = "Microsoft.3DBuilder","Microsoft.BingFinance","Microsoft.BingNews","Microsoft.BingSports","Microsoft.BingWeather","Microsoft.Getstarted","Microsoft.Messaging","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.Office.OneNote","Microsoft.Office.Sway","Microsoft.OneConnect","Microsoft.People","Microsoft.SkypeApp","Microsoft.WindowsAlarms","microsoft.windowscommunicationsapps","Microsoft.WindowsFeedbackHub","Microsoft.WindowsMaps","Microsoft.WindowsPhone","Microsoft.XboxApp","Microsoft.XboxIdentityProvider","Microsoft.ZuneMusic","Microsoft.ZuneVideo"
ForEach ($App in $AppsList) {
    $Packages = Get-AppxPackage -AllUsers -EA SilentlyContinue | Where-Object {$_.Name -eq $App}
    if ($Packages -ne $null) {
        $Compliance = $False
    }
}
return $Compliance