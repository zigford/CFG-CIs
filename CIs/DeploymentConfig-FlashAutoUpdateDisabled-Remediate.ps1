$FilePath = "$($env:windir)\system32\Macromed\Flash\mms.cfg"
If ( -Not (Test-Path -Path (Split-Path -Path $FilePath -Parent))) {
    New-Item -Path "$($env:windir)\system32\Macromed" -Name Flash -ItemType Directory 
}
$MMSContent = @"
AutoUpdateDisable=1
"@
Set-Content -Path $FilePath -Value $MMSContent -Force