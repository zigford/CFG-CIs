﻿Import-Module AppvClient
$PackageID = "e650d790-71f8-4082-9a40-701fffcbdbae"
$VersionID = "ee6880d9-15bc-4a8a-bd60-7540777092c4"

$NewConfigFile = @"
<?xml version="1.0"?>
<UserConfiguration PackageId="e650d790-71f8-4082-9a40-701fffcbdbae" DisplayName="MEX_MEX_12.5.3_APPV_Site_USR,WKS" xmlns="http://schemas.microsoft.com/appv/2010/userconfiguration"><Subsystems><Shortcuts Enabled="true"><Extensions><Extension Category="AppV.Shortcut"><Shortcut><File>[{Common Programs}]\MEX 12\MEX 12.5.3 - Live.lnk</File><Target>[{AppVPackageRoot}]\MEX.exe</Target><Icon>[{Windows}]\Installer\{56C4098C-5128-4C52-93D4-45AB2291AA42}\NewShortcut4_6CD26868F1FF435E8C174997E819929A.exe.0.ico</Icon><Arguments></Arguments><WorkingDirectory></WorkingDirectory><ShowCommand>1</ShowCommand><ApplicationId>[{AppVPackageRoot}]\MEX.exe</ApplicationId></Shortcut></Extension><Extension Category="AppV.Shortcut"><Shortcut><File>[{Common Programs}]\MEX 12\MEX Diagnostic Tool Live.lnk</File><Target>[{AppVPackageRoot}]\MexDiagnosticsUtility.exe</Target><Icon>[{Windows}]\Installer\{56C4098C-5128-4C52-93D4-45AB2291AA42}\NewShortcut2_B67FC477B6EE489490E2694494FC6474.exe.0.ico</Icon><Arguments></Arguments><WorkingDirectory></WorkingDirectory><ShowCommand>1</ShowCommand><ApplicationId>[{AppVPackageRoot}]\MexDiagnosticsUtility.exe</ApplicationId></Shortcut></Extension><Extension Category="AppV.Shortcut"><Shortcut><File>[{Common Programs}]\MEX 12\MEX Help.lnk</File><Target>[{AppVPackageRoot}]\MEX12UserGuide.chm</Target><Icon>[{Windows}]\Installer\{56C4098C-5128-4C52-93D4-45AB2291AA42}\NewShortcut3_A4B270A6BC7E4F38A1FBEA48FE0F700B.exe.0.ico</Icon><Arguments></Arguments><WorkingDirectory></WorkingDirectory><ShowCommand>1</ShowCommand></Shortcut></Extension></Extensions></Shortcuts><FileTypeAssociations Enabled="true"></FileTypeAssociations><URLProtocols Enabled="true"></URLProtocols><COM Mode="Integrated"><IntegratedCOMAttributes OutOfProcessEnabled="false" InProcessEnabled="false"></IntegratedCOMAttributes></COM><Objects Enabled="false"></Objects><Registry Enabled="true"></Registry><FileSystem Enabled="true"></FileSystem><Fonts Enabled="true"></Fonts><EnvironmentVariables Enabled="true"></EnvironmentVariables><Services Enabled="true"></Services></Subsystems><Applications><Application Id="[{AppVPackageRoot}]\MEX.exe" Enabled="true"><VisualElements><Name>MEX 12.5.3 - Live</Name><Icon></Icon><Description></Description></VisualElements></Application><Application Id="[{AppVPackageRoot}]\MexDiagnosticsUtility.exe" Enabled="true"><VisualElements><Name>MEX Diagnostic Tool Live</Name><Icon></Icon><Description></Description></VisualElements></Application><Application Id="[{AppVPackageRoot}]\MEX12UserGuide.chm" Enabled="true"><VisualElements><Name>MEX Help</Name><Icon></Icon><Description></Description></VisualElements></Application></Applications></UserConfiguration>
"@

$pkg = Get-AppvClientPackage -PackageId $PackageID -VersionId $VersionID
$ConfigPath = $pkg.GetDynamicUserConfigurationPath($false)
$CurrentConfigFile = (Get-Content $ConfigPath -Raw)

$CurrentConfigFile = $CurrentConfigFile.Trim()
$NewConfigFile = $NewConfigFile.Trim()
$CurrentConfigFile | Out-File -FilePath "$($env:TEMP)\Current.log"
$NewConfigFile | Out-File -FilePath "$($env:TEMP)\New.log"

$NewConfigFile = Get-Content -Path "$($env:TEMP)\New.log"
$CurrentConfigFile = Get-Content -Path "$($env:TEMP)\Current.log"

If (Compare-Object $NewConfigFile $CurrentConfigFile) {
    $False
} Else {
    $True
}