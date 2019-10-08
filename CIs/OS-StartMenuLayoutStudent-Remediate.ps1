[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-StartMenuLayoutStudent-Remediate.log"
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
  logMsg "Succesfully cast Here-Doc to XML type"
} Catch {
  logMsg "Failed to cast Here-Doc to tyep XML"
  Write-Error "Unable to instantiate Here-Doc"
}

# Attempting to Save to local Random XML location
$NewItemParams = @{
    Path = $env:temp
    Name = "$(Get-Random).xml"
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
logMsg "Importing Start-Layout"
Try {
    Import-StartLayout -LayoutPath $RandomFile.FullName -MountPath "$($env:SystemDrive)\"
    logMsg "Succesfully imported new Start-Layout"
} catch {
    logMsg "Failed to Import Start layout" 1
}
logMsg "Deleting temp XML file"
Try {
    $RandomFile | Remove-Item -Force
    logMsg "Succesfully removed temp file $($RandomFile.FullName)"
} catch {
    logMsg "Couldn't removed temp file $($RandomFile.FullName)" 2
}