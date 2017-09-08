#Test of Bad files which can lock default profile
$Logfile = "$ENV:SystemRoot\AppLog\$($MyInvocation.MyCommand).log"
#Start-Transcript -Path $Logfile
$VerbosePreference = 'SilentlyContinue'
$AssumeResult = $True
$BadFiles = 'Roaming\Microsoft\VisualStudio\14.0\FeedCache\*.xml','Local\Microsoft\VSCommon\14.0\SQM\*.sqm'
$ProfilePath = "$ENV:SystemDrive\Users\Default\AppData"
#Write-Verbose "Testing paths"
ForEach ($ChildPath in $BadFiles) {
#    Write-Verbose "Testing $ProfilePath\$ChildPath"
    If (Get-ChildItem -Path "$ProfilePath\$ChildPath" -EA SilentlyContinue) {
#        Write-Verbose "Setting result to false"
        $AssumeResult = $false
    }
}
$AssumeResult
#Stop-Transcript