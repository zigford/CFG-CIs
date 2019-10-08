﻿[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-StartMenuLayoutStaff-Remediate.log"
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
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
	xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
	xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
	xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
	xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
	Version="1">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride LayoutCustomizationRestrictionType="OnlySpecifiedGroups">
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
        <start:Group Name="My Everyday Applications and Data" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\OneNote 2016.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk" />
        </start:Group>
        <start:Group Name="Windows 10 Apps" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
          <start:Tile Size="2x2" Column="4" Row="2" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.calendar" />
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail" />
          <start:Tile Size="4x4" Column="0" Row="0" AppUserModelID="Microsoft.BingWeather_8wekyb3d8bbwe!App" />
        </start:Group>
        <start:Group Name="" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
          <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
<CustomTaskbarLayoutCollection PinListPlacement="Replace">
  <defaultlayout:TaskbarLayout>
    <taskbar:TaskbarPinList>
	<taskbar:DesktopApp DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" />
	<taskbar:UWA AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
	<taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
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
#19-08-2018 Newer builds of office use different office shortcut names
#here we will check which type the system has
logMsg "Testing office shortcut type"  
$OldIcons = $True
$NewIcons = $True
$TestList = 'Word','Outlook','Excel','PowerPoint'
$IconLoc  = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs"
ForEach ($Icon in $TestList) {
    $NewPath = "$IconLoc\$Icon.lnk"
    $OldPath = "$IconLoc\$Icon 2016.lnk"
    If (Test-Path -Path $OldPath) {
        $NewIcons = $False
    } ElseIf (Test-Path $NewPath) {
        $OldIcons = $False
    }
}
If ($OldIcons -and ($NewIcons -eq $False)) {
    #Nothing to do here as icons are still the old style
    logMsg "Older 2016 icons"
} ElseIf ($NewIcons -and ($OldIcons -eq $False)) {
    logMsg "New icons without 2016. Update XML on the fly"
    Try {
        $NewContent = Get-Content -Path $RandomFile.FullName | ForEach-Object {
            If ($_ -match 'Programs\\(?!OneNote)(\w+\s)+2016') {
                $_ -replace ' 2016',''
            } else {
                $_
            }
        }
        $NewContent | Out-File $RandomFile.FullName
    } catch {
        logMsg "Failed to update xml with new icon names"
    }
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
