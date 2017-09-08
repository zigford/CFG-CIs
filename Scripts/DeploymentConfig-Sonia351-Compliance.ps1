Import-Module AppvClient
$PackageID = "4fcd0002-2b3f-47df-bffa-2c1df503c2b5"
$VersionID = "1a623915-3591-42e6-b66b-1ee08b746f10"

$NewConfigFile = @"
<?xml version="1.0"?>
<UserConfiguration PackageId="4fcd0002-2b3f-47df-bffa-2c1df503c2b5" DisplayName="PlanetSoftware_Sonia_3.8.5.1_APPV_Site_USR,WKS" xmlns="http://schemas.microsoft.com/appv/2010/userconfiguration"><Subsystems><Shortcuts Enabled="true"><Extensions><Extension Category="AppV.Shortcut"><Shortcut><File>[{Common Programs}]\Planet Software\Sonia\Sonia 3.8.5.1 Live.lnk</File><Target>[{ProgramFilesX86}]\Planet Software\Sonia\Sonia.exe</Target><Icon>[{ProgramFilesX86}]\Planet Software\Sonia\Sonia.exe.0.ico</Icon><Arguments></Arguments><WorkingDirectory>[{ProgramFilesX86}]\Planet Software\Sonia\</WorkingDirectory><Description>Sonia</Description><ShowCommand>1</ShowCommand><ApplicationId>[{ProgramFilesX86}]\Planet Software\Sonia\Sonia.exe</ApplicationId></Shortcut></Extension></Extensions></Shortcuts><FileTypeAssociations Enabled="true"></FileTypeAssociations><URLProtocols Enabled="true"></URLProtocols><COM Mode="Integrated"><IntegratedCOMAttributes OutOfProcessEnabled="false" InProcessEnabled="false"></IntegratedCOMAttributes></COM><Objects Enabled="false"></Objects><Registry Enabled="true"></Registry><FileSystem Enabled="true"></FileSystem><Fonts Enabled="true"></Fonts><EnvironmentVariables Enabled="true"></EnvironmentVariables><Services Enabled="true"></Services></Subsystems><Applications><Application Id="[{ProgramFilesX86}]\Planet Software\Sonia\Sonia.exe" Enabled="true"><VisualElements><Name>Sonia 3.8.5.1 Live</Name><Icon></Icon><Description></Description></VisualElements></Application></Applications></UserConfiguration>
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