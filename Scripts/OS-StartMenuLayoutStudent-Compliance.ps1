[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-StartMenuLayoutStudent-Compliance.log"
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

$InstalledXMLPath = "$($env:Systemdrive)\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
logMsg "Reading installed Start Layout"
Try {
  $InstalledXML = (Get-Content -Path $InstalledXMLPath)
  logMsg "Succesfully imported installed Start Layout"
} Catch {
  logMsg "Failed to import installed Start Layout"
  Write-Error "Unable to read XML file $InstalledXMLPath"
}

logMsg "Instantiating Here-Doc for XML to compare"
Try {
$NewXML = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
<LayoutOptions StartTileGroupCellWidth="6"/>
<DefaultLayoutOverride>
    <StartLayoutCollection>
        <defaultlayout:StartLayout GroupCellWidth="6">
            <start:Group Name="My Everyday Applications and Data">
                <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\OneNote 2016.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Blackboard Learn.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Student Mail.lnk"/>
            </start:Group>
            <start:Group Name="">
                <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk"/>
                <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"/>
                <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"/>
                <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"/>
            </start:Group>
        </defaultlayout:StartLayout>
    </StartLayoutCollection>
</DefaultLayoutOverride>
<CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
        <taskbar:TaskbarPinList>
            <taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"/>
            <taskbar:UWA AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge"/>
            <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk"/>
        </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
</CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
  logMsg "Succesfully instantiated Here-Doc to string"
} Catch {
  logMsg "Failed to instantiate Here-Doc"
  Write-Error "Unable to instantiate Here-Doc"
}
# Lets save it to disk so we can import it as an object
$NewItemParams = @{
  Path = $env:temp
  Name = "$(Get-Random).xml"
  Value = $NewXML
}
logMsg ("Creating Temp File {0} for XML" -f $NewItemParams.Name)
Try {
  $RandomFile = New-Item @NewItemParams -ItemType File
  logMsg "Succesfully created temp XML file $($NewItemParams.Name)"
} catch {
  logMsg "Failed to create temp XML file $($NewItemParams.Name)" 1
}
logMsg "Saving XML to disk"
Try {
  #$NewXML.Save($RandomFile.FullName)
  $NewXML | Out-File -FilePath $RandomFile.FullName
  logMsg "Sucesfully saved XML"
} catch {
  logMsg "Failed to save XML" 1
}
logMsg "Importing XML with Get-Content to get it as an object of strings"
Try {
  $NewXMLContent = Get-Content -Path $RandomFile.FullName
  logMsg "Succesfully read temp file $($RandomFile.FullName)"
  # Can Delete Temp file now
} catch {
  logMsg "Failed to read saved XML" 1
}

Try {
  $RandomFile | Remove-Item -Force
  logMsg "Succesfully removed temp file $($RandomFile.FullName)"
} catch {
  logMsg "Could not remove temp file" 2
}

If (Compare-Object -ReferenceObject $InstalledXML -DifferenceObject $NewXMLContent) {
  # there is a difference
  logMsg "Installed start layout does not match Here-Doc. Returning False"
  return $False
} else {
  logMsg "Installed start layout matches Here-Doc. Returning True"
  return $True
}