Import-module Appvclient
$Pkg = Get-AppvclientPackage -PackageId 36c97f90-198f-45ce-b4bf-b527faa1da68
$ConfigPath = $Pkg.GetDynamicUserConfigurationPath($false)

$NewConfigFile=@"
<?xml version="1.0"?>
<UserConfiguration PackageId="36c97f90-198f-45ce-b4bf-b527faa1da68" DisplayName="PlanetSoftware Sonia 3.7.1 - Live" xmlns="http://schemas.microsoft.com/appv/2010/userconfiguration"><ManagingAuthority TakeoverExtensionPointsFrom46="true" PackageName="36c97f90-198f-45ce-b4bf-b527faa1da68"></ManagingAuthority><Subsystems><Shortcuts Enabled="true"><Extensions><Extension Category="AppV.Shortcut"><Shortcut><File>[{Programs}]\Planet Software\Sonia\Sonia 3.7.1 - Live.lnk</File><Target>[{AppVPackageRoot}]\Sonia.exe</Target><Arguments></Arguments><Icon>[{AppVPackageRoot}]\ApplicationIcons\Sonia 3.7.1.0.ico</Icon><WorkingDirectory>[{AppVPackageRoot}]\</WorkingDirectory><ApplicationId>[{AppVPackageRoot}]\Sonia.exe</ApplicationId></Shortcut></Extension></Extensions></Shortcuts><FileTypeAssociations Enabled="true"></FileTypeAssociations><URLProtocols Enabled="true"></URLProtocols><COM Mode="Isolated"><IntegratedCOMAttributes OutOfProcessEnabled="true" InProcessEnabled="false"></IntegratedCOMAttributes></COM><Objects Enabled="false"></Objects><Registry Enabled="true"></Registry><FileSystem Enabled="true"></FileSystem><Fonts Enabled="true"></Fonts><EnvironmentVariables Enabled="true"></EnvironmentVariables><Services Enabled="true"></Services></Subsystems><Applications><Application Id="[{AppVPackageRoot}]\Sonia.exe" Enabled="true"><VisualElements><Name>Sonia 3.7.1.0</Name><Icon>[{AppVPackageRoot}]\ApplicationIcons\Sonia 3.7.1.0.ico</Icon><Description></Description></VisualElements></Application></Applications></UserConfiguration>
"@

$pkg = Get-AppvClientPackage -PackageId 36c97f90-198f-45ce-b4bf-b527faa1da68
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