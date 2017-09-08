$Logfile = "$ENV:SystemRoot\AppLog\$($MyInvocation.MyCommand).log"
#Test of Bad files which can lock default profile
Start-Transcript -Path $Logfile
$VerbosePreference = 'Continue'
$BadFiles = 'Roaming\Microsoft\VisualStudio\14.0\FeedCache\*.xml','Local\Microsoft\VSCommon\14.0\SQM\*.sqm'
$ProfilePath = "$ENV:SystemDrive\Users\Default\AppData"
ForEach ($ChildPath in $BadFiles) {
    Get-ChildItem -Path "$ProfilePath\$ChildPath" -EA SilentlyContinue | ForEach-Object {
        Write-Verbose "Attempting to remove $($_.FullName)"
        Remove-Item $_ 
    }
}
Stop-Transcript