Start-Process -FilePath C:\Windows\System32\reg.exe -ArgumentList 'load "HKLM\DU" "C:\Users\Default User\NTUSER.DAT"' -Wait
Remove-Item -Path 'HKLM:\DU\Software\Apple Computer, Inc.\QuickTime\LocalUserPreferences' -Force
[gc]::Collect() | Out-Null
Start-process -FilePath C:\Windows\System32\reg.exe -ArgumentList 'unload "HKLM\DU"' -Wait