$Global:logFile = "$($env:systemroot)\AppLog\OS-StartMenuLayoutShared-Remediate.log"
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}
# Here we have the new XML directly embedded as a here doc, and again, cast as an XML object
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

# Create a new temp file
$NewItemParams = @{
  Path = $env:temp
  Name = "$(Get-Random).xml"
}
logMsg ("Creating File {0}\{1}" -f $NewItemParams.Path,$NewItemParams.Name)
$TempXML = New-Item @NewItemParams -ItemType File
# Save the XML to the temp file
logMsg "Saving XML"
$NewXML.Save($TempXML.FullName)

# Time to Import the new Start-Layout
logMsg "Importing XML file"
Import-StartLayout -LayoutPath $TempXML -MountPath "$($env:SystemRoot)\"