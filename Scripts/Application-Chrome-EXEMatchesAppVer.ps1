$ChromeDir = "${env:ProgramFiles(x86)}\Google\Chrome\Application"
$ChromeVer = (Get-Item -Path "$ChromeDir\chrome.exe").VersionInfo.FileVersion
$AppDirExists = Test-Path -Path "$ChromeDir\$ChromeVer"
$AppDirExists