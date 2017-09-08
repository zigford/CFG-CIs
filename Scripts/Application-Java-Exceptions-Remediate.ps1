$ExceptionsFile = "$env:userprofile\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
$JavaExceptions='https://online.usc.edu.au/'

If (!(Test-Path -Path $ExceptionsFile)) {
    New-Item -Path $ExceptionsFile -ItemType File -Value $JavaExceptions -Force
}
Add-Content -Path $ExceptionsFile -Value $JavaExceptions