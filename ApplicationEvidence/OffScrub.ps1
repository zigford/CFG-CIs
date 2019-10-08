$RegPathExists = Test-Path HKLM:\Software\Microsoft\Office\ClickToRun\Configuration
$FilePathExists = $False
$env:ProgramFiles,${env:ProgramFiles(x86)} | %{If (Test-Path -Path "$_\Microsoft Office\root"){$FilePathExists = $True}}

If (-Not $RegPathExists -and -Not $FilePathExists) {
    "We installed correctly"
}