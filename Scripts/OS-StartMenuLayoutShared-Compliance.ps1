$Global:logFile = "$($env:Systemroot)\AppLog\OS-StartMenuLayoutShared-Compliance.log"

function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}

logMsg "Importing Installed XML"
$InstalledXMLPath = "$($env:Systemdrive)\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
# We import the XML and cast it as an XML type so that it is easy to compare as an object
$InstalledXML = [xml](Get-Content -Path $InstalledXMLPath -Raw)
# Here we have the new XML directly embedded as a here doc, and again, cast as an XML object
logMsg "Casting new XML"
$NewXML = [xml]@"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
<LayoutOptions StartTileGroupCellWidth="6" />
<DefaultLayoutOverride>
  <StartLayoutCollection>
    <defaultlayout:StartLayout GroupCellWidth="6">
      <start:Group Name="My Everyday Applications and Data">
        <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\OneNote 2016.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Blackboard Learn.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Student Mail.lnk" />
      </start:Group>
      <start:Group Name="">
        <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk" />
        <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
        <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
        <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
      </start:Group>
    </defaultlayout:StartLayout>
  </StartLayoutCollection>
</DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

logMsg "Comparing XML's"
If (Compare-Object -ReferenceObject $InstalledXML -DifferenceObject $NewXML) {
  logMsg "Installed Start-Layout is not compliant, returning False"
  # If Compare object returns any data, that means there is a difference between the XML
  # data and we will return false, as the Source XML does not match, the installed and is not
  # compliant.
  return $False
} else {
  logMsg "Installed Start-Layout matches CI, returning True"
  return $True
}
