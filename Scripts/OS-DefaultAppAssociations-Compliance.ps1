[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-DefaultAppAssociations-Compliance.log"
$ErrorActionPreference = 'Stop'

function logMsg {
  [CmdLetBinding()]
  Param(
      [Parameter(
          ValueFromPipeline=$True
      )]$Message,
      $Level=0,
      $logFile=$Global:logFile
  )
  "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
  Switch ($Level){
    1 {Write-Error -Message $Message}
    2 {Write-Warning -Message $Message}
    Default {Write-Verbose -Message $Message}
  }
}

$InstalledXMLPath = "$($env:Systemroot)\System32\OEMDefaultAssociations.xml"
logMsg "Testing for existence of Default Association File"
If (Test-Path -Path $InstalledXMLPath) {
  logMsg "Association file present. Returning True"
  return $True
} Else {
  logMsg "Association file does not exist. Returning False"
  return $False
}