Import-Module AppvClient
$PackageID = "36c97f90-198f-45ce-b4bf-b527faa1da68"
$VersionID = "03bae852-3bea-40b9-9d29-04fc59119aa7"

$NewConfigFile = @"
<?xml version="1.0"?>
<UserConfiguration PackageId="36c97f90-198f-45ce-b4bf-b527faa1da68" DisplayName="PlanetSoftware Sonia 3.7.1 - Live" xmlns="http://schemas.microsoft.com/appv/2010/userconfiguration"><ManagingAuthority TakeoverExtensionPointsFrom46="true" PackageName="36c97f90-198f-45ce-b4bf-b527faa1da68"></ManagingAuthority><Subsystems><Shortcuts Enabled="true"><Extensions><Extension Category="AppV.Shortcut"><Shortcut><File>[{Programs}]\Planet Software\Sonia\Sonia 3.7.1 - Live.lnk</File><Target>[{AppVPackageRoot}]\Sonia.exe</Target><Arguments></Arguments><Icon>[{AppVPackageRoot}]\ApplicationIcons\Sonia 3.7.1.0.ico</Icon><WorkingDirectory>[{AppVPackageRoot}]\</WorkingDirectory><ApplicationId>[{AppVPackageRoot}]\Sonia.exe</ApplicationId></Shortcut></Extension></Extensions></Shortcuts><FileTypeAssociations Enabled="true"></FileTypeAssociations><URLProtocols Enabled="true"></URLProtocols><COM Mode="Isolated"><IntegratedCOMAttributes OutOfProcessEnabled="true" InProcessEnabled="false"></IntegratedCOMAttributes></COM><Objects Enabled="false"></Objects><Registry Enabled="true"></Registry><FileSystem Enabled="true"></FileSystem><Fonts Enabled="true"></Fonts><EnvironmentVariables Enabled="true"></EnvironmentVariables><Services Enabled="true"></Services></Subsystems><Applications><Application Id="[{AppVPackageRoot}]\Sonia.exe" Enabled="true"><VisualElements><Name>Sonia 3.7.1.0</Name><Icon>[{AppVPackageRoot}]\ApplicationIcons\Sonia 3.7.1.0.ico</Icon><Description></Description></VisualElements></Application></Applications></UserConfiguration>
"@

$NewConfigFile = $NewConfigFile.Trim()
$NewConfigPath = New-Item -Path $env:Temp -Name (Get-Random) -ItemType File -Value $NewConfigFile
Unpublish-AppvClientPackage -PackageId $PackageID -VersionId $VersionID
Publish-AppvClientPackage -PackageId $PackageID -VersionId $VersionID -DynamicUserConfigurationPath $NewConfigPath