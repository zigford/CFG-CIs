[CmdLetBinding()]
Param($DefaultParam)

$Global:logFile = "$($env:windir)\AppLog\OS-DefaultAppAssociations-Remediate.log"
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

$AssociationXML = Switch (Get-OSBuild) {
  14393 {
    logMsg "Detected Anniversary Update"
#region 14393
    @"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".3g2" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".3gp" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".3gpp" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".AAC" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".ADT" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".ADTS" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".amr" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".avi" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".bmp" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".dib" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".docx" ProgId="Word.Document.12" ApplicationName="Word 2016" />
  <Association Identifier=".flac" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".gif" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".hxw" ProgId="MSHelp.hxa.2.5" />
  <Association Identifier=".jfif" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpe" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpeg" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpg" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jxr" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".M2T" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".M2TS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".m3u" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4a" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4r" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4v" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mkv" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".MOD" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mov" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mp3" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".mp4" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mp4v" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mpa" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".mpv2" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".MTS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".odt" ProgId="Word.OpenDocumentText.12" ApplicationName="Word 2016" />
  <Association Identifier=".oxps" ProgId="Windows.OXPSConverter" ApplicationName="OXPS to XPS Converter" />
  <Association Identifier=".pdf" ProgId="Acrobat.Document.DC" ApplicationName="Adobe Acrobat DC" />
  <Association Identifier=".png" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".ppkg" ProgId="Microsoft.ProvTool.Provisioning.1" ApplicationName="Provisioning package runtime processing tool" />
  <Association Identifier=".rtf" ProgId="Word.RTF.8" ApplicationName="Word 2016" />
  <Association Identifier=".TS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".TTS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".wav" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".wdp" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".wm" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".wma" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".wmv" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".wpl" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".xml" ProgId="xmlfile" ApplicationName="Office XML Handler" />
  <Association Identifier=".xvid" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".zpl" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook 2016" />
  <Association Identifier="mswindowsmusic" ProgId="AppXtggqqtcfspt6ks3fjzyfppwc05yxwtwy" ApplicationName="Groove Music" />
  <Association Identifier="mswindowsvideo" ProgId="AppX6w6n4f8xch1s3vzwf3af6bfe88qhxbza" ApplicationName="Films &amp; TV" />
</DefaultAssociations>
"@

#endregion
  }
  15063 {
    logMsg "Detected Creators Update"
#region 15063
@"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".3g2" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".3gp" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".3gp2" ProgId="WMP11.AssocFile.3G2" ApplicationName="Windows Media Player" />
  <Association Identifier=".3gpp" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".3mf" ProgId="AppXvhc4p7vz4b485xfp46hhk3fq3grkdgjg" ApplicationName="3D Builder" />
  <Association Identifier=".aac" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".adt" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".adts" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".amr" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".arw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".avi" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".bmp" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".cr2" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".crw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".dib" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".epub" ProgId="AppXvepbp3z66accmsd0x877zbbxjctkpr6t" ApplicationName="Microsoft Edge" />
  <Association Identifier=".erf" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".flac" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".gif" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".jfif" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpe" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpeg" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jpg" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".jxr" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".kdc" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".m2t" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".m2ts" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".m3u" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4a" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4r" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".m4v" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mkv" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mod" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mov" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".MP2" ProgId="WMP11.AssocFile.MP3" ApplicationName="Windows Media Player" />
  <Association Identifier=".mp3" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".mp4" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mp4v" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mpa" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".mpeg" ProgId="WMP11.AssocFile.mpeg" ApplicationName="Windows Media Player" />
  <Association Identifier=".mpv2" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".mrw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".mts" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".nef" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".nrw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".orf" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".oxps" ProgId="Windows.XPSReachViewer" ApplicationName="XPS Viewer" />
  <Association Identifier=".pdf" ProgId="AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723" ApplicationName="Microsoft Edge" />
  <Association Identifier=".pef" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".png" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".raf" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".raw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".rw2" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".rwl" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".sr2" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".srw" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".stl" ProgId="AppXvhc4p7vz4b485xfp46hhk3fq3grkdgjg" ApplicationName="3D Builder" />
  <Association Identifier=".tif" ProgId="PhotoViewer.FileAssoc.Tiff" ApplicationName="Windows Photo Viewer" />
  <Association Identifier=".tiff" ProgId="PhotoViewer.FileAssoc.Tiff" ApplicationName="Windows Photo Viewer" />
  <Association Identifier=".TS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".TTS" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".txt" ProgId="txtfile" ApplicationName="Notepad" />
  <Association Identifier=".url" ProgId="IE.AssocFile.URL" ApplicationName="Internet Browser" />
  <Association Identifier=".wav" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".wdp" ProgId="AppX43hnxtbyyps62jhe9sqpdzxn1790zetc" ApplicationName="Photos" />
  <Association Identifier=".website" ProgId="IE.AssocFile.WEBSITE" ApplicationName="Internet Explorer" />
  <Association Identifier=".wm" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".wma" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".wmv" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".WPL" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier=".xps" ProgId="Windows.XPSReachViewer" ApplicationName="XPS Viewer" />
  <Association Identifier=".xvid" ProgId="AppX6eg8h5sxqq90pv53845wmnbewywdqq5h" ApplicationName="Films &amp; TV" />
  <Association Identifier=".zpl" ProgId="AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs" ApplicationName="Groove Music" />
  <Association Identifier="bingmaps" ProgId="AppXp9gkwccvk6fa6yyfq3tmsk8ws2nprk1p" ApplicationName="Maps" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook 2016" />
  <Association Identifier="mswindowsmusic" ProgId="AppXtggqqtcfspt6ks3fjzyfppwc05yxwtwy" ApplicationName="Groove Music" />
  <Association Identifier="mswindowsvideo" ProgId="AppX6w6n4f8xch1s3vzwf3af6bfe88qhxbza" ApplicationName="Films &amp; TV" />
</DefaultAssociations>
"@

#endregion
  }
  16299 {
    logMsg "Detected Fall Creators Update"
#region 16299
@"
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

#endregion
  }
  {$_ -ge 17763} {
    logMsg "Detected 1809"
#region 1809
@"
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier=".html" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="http" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="https" ProgId="ChromeHTML" ApplicationName="Google Chrome" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook 2016" />
</DefaultAssociations>
"@

#endregion
    }
}

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
  ([xml]$AssociationXML).Save($RandomFile.FullName)
  logMsg "Sucesfully saved XML"
} catch {
  logMsg "Failed to save XML" 1
}
logMsg "Attempting to import Default App Associations with DISM"
& Dism.exe /Online /Import-DefaultAppAssociations:"$($RandomFile.FullName)"
if ($?){
  logMsg "Succesfully applied default app associations"
} else {
  logMsg "Failed to apply default app associations" 1
}
logMsg "Deleting temp XML file"
Try {
    $RandomFile | Remove-Item -Force
    logMsg "Succesfully removed temp file $($RandomFile.FullName)"
} catch {
    logMsg "Couldn't removed temp file $($RandomFile.FullName)" 2
}