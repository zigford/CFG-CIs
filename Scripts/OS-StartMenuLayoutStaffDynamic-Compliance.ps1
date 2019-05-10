[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-StartMenuLayoutStaff-Compliance.log"
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

function Get-WinBuildList {
  [CmdLetBinding()]
  Param(
      [ValidateSet(
          "1507",
          "1511",
          "1607",
          "1703",
          "1709",
          "1803",
          "1809"
      )]
      [int]$Release,
      [switch]$AsHashTable
  )

  $Builds = @{
      '1507' = '10240'
      '1511' = '10586'
      '1607' = '14393'
      '1703' = '15063'
      '1709' = '16299'
      '1803' = '17134'
      '1809' = '17763'
  }

  If ($Release) {
      $Result = $Builds.GetEnumerator() | Where-Object {$PSItem.Name -eq $Release}
  } else {
      $Result = $Builds
  }

  If ($AsHashTable) {
      return $Result
  } else {
      If ($Result.GetType().Name -eq 'HashTable') {
          $Result = $Result.GetEnumerator()
      }
      $Object = $Result | ForEach-Object {
          [PSCustomObject]@{
              'Release' = $PSItem.Name
              'Build' = $PSItem.Value
          }
      }
      return ($Object | Sort-Object -Property Release)
  }
}

Switch (Get-OSBuild) {
    {$_ -ge $(Get-WinBuildList -Release 1803).Build} {
        logMsg "Win10 release 1803 or higher, using DesktopAppID layout mode"
        $LayoutStyle = 'DesktopAppID'
    }
    Default {
        logMsg "Win10 release 1709 or lower, using Standard layout mode"
        $LayoutStyle = 'Standard'
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
    If ($LayoutStyle -eq 'Standard') {
#region standardlayout
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
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim" />
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
#endregion
    } else {
#region DesktopAppID layout
        $NewXML =@"
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
	xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6">
        <start:Group Name="My Everyday Applications and Data">
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationID="Microsoft.Office.lync.exe.15" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationID="Microsoft.Office.WINWORD.EXE.15" />
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="2" DesktopApplicationID="Microsoft.Office.EXCEL.EXE.15" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationID="Microsoft.Office.OUTLOOK.EXE.15" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="2" DesktopApplicationID="Microsoft.Office.POWERPNT.EXE.15" />
        </start:Group>
        <start:Group Name="Windows 10 Apps">
          <start:Tile Size="2x2" Column="4" Row="0" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!Microsoft.WindowsLive.Mail" />
          <start:Tile Size="2x2" Column="4" Row="2" AppUserModelID="microsoft.windowscommunicationsapps_8wekyb3d8bbwe!Microsoft.WindowsLive.Calendar" />
          <start:Tile Size="4x4" Column="0" Row="0" AppUserModelID="Microsoft.BingWeather_8wekyb3d8bbwe!App" />
        </start:Group>
        <start:Group Name="">
          <start:Tile Size="2x2" Column="2" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft System Center\Configuration Manager\Software Center.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationID="Chrome" />
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationID="Microsoft.Windows.Explorer" />
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
#endregion
    }
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
  $NewXML | Out-File -FilePath $RandomFile.FullName -Encoding utf8
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
If (($OldIcons -and ($NewIcons -eq $False)) -or $LayoutStyle -eq 'DesktopAppID') {
    #Nothing to do here as icons are still the old style
    logMsg "Older 2016 icons or using DesktopAppID"
} ElseIf ($NewIcons -and ($OldIcons -eq $False)) {
    logMsg "New icons without 2016. Update XML on the fly"
    Try {
        $NewContent = Get-Content -Path $RandomFile.FullName
        $NewContent | ForEach-Object {
            If ($_ -match 'Programs\\(?!OneNote)(\w+\s)+2016') {
                $_ -replace ' 2016',''
            } else {
                $_
            }
        } | Out-File $RandomFile.FullName -Encoding utf8
    } catch {
        logMsg "Failed to update xml with new icon names"
    }
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

If (Compare-Object -ReferenceObject $InstalledXML.Trim() -DifferenceObject $NewXMLContent.Trim()) {
    # there is a difference
    logMsg "Installed start layout does not match Here-Doc. Returning False"
    return $False
} else {
    logMsg "Installed start layout matches Here-Doc. Returning True"
    return $True
}