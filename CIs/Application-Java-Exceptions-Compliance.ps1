$JavaExceptions='https://online.usc.edu.au/','https://online.usc.edu.au'
$ExceptionsFile = "$env:userprofile\AppData\LocalLow\Sun\Java\Deployment\security\exception.sites"
$SiteAdded = $False

If (Test-Path -Path $ExceptionsFile) {
    #Check contents of file
    ForEach ($Exception in $JavaExceptions) {
        If ($Exception -in (Get-Content -Path $ExceptionsFile)) {
            $SiteAdded = $True
        }
    }
}

$SiteAdded