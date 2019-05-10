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

function Get-OSBuild {
    cmd.exe /c ver 2>$null | ForEach-Object {
        $v = ([regex]'(\d+(\d+|\.)+)+').Matches($_).Value
        if ($v) {
            [Version]::Parse($v).Build
        }
    }
}

$InstalledXMLPath = "$($env:Systemroot)\System32\OEMDefaultAssociations.xml"
$Compliance = $False

Switch (Get-OSBuild) {
    {$_ -le "15063"} {
        logMsg "1703 or younger detected. Just checking for file"
        If (Test-Path -Path $InstalledXMLPath) {
          logMsg "Association file present. Returning True"
          $Compliance = $True
        } Else {
          logMsg "Association file does not exist. Returning False"
          $Compliance = $False
        }
    }
    {$_ -ge 16299 -and $_ -le 17134} {
        logMsg "1709 or greater detected. Checking XML content"
        $TrueXML = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".pdf" ProgId="Acrobat.Document.DC" ApplicationName="Adobe Acrobat DC" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook 2016" />
</DefaultAssociations>
"@
        If (Test-Path -Path $InstalledXMLPath) {
            $RandomName = "$env:temp\$(Get-Random).xml"
            logMsg "Creating temp file $RandomName"
            ([xml]$TrueXML).Save($RandomName)
            If (Compare-Object (Get-Content $InstalledXMLPath) (Get-Content $RandomName)) {
                logMsg "Association file does not match desired configuration. Returning False"
                $Compliance = $False
            } Else {
                logMsg "Association file matches desired configuration. Returning True"
                $Compliance = $True
            }
            Remove-Item $RandomName
        } Else {
            logMsg "Association file does not exist. Returning False"
            $Compliance = $False
        }
    }
    Default {
        logMsg "1809 or greater detected. Checking XML content"
        $TrueXML = @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook 2016" />
</DefaultAssociations>
"@
        If (Test-Path -Path $InstalledXMLPath) {
            $RandomName = "$env:temp\$(Get-Random).xml"
            logMsg "Creating temp file $RandomName"
            ([xml]$TrueXML).Save($RandomName)
            If (Compare-Object (Get-Content $InstalledXMLPath) (Get-Content $RandomName)) {
                logMsg "Association file does not match desired configuration. Returning False"
                $Compliance = $False
            } Else {
                logMsg "Association file matches desired configuration. Returning True"
                $Compliance = $True
            }
            Remove-Item $RandomName
        } Else {
            logMsg "Association file does not exist. Returning False"
            $Compliance = $False
        }
    }
}

return $Compliance