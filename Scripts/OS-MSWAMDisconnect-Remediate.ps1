
##### WAM Disconnect Script V1.5 #####
 
#### Add WAM ADAL Override to Registry ####
reg add "HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Identity" /v DisableADALatopWAMOverride /t REG_DWORD /d 1 /f
 
#### Create Settings Rollback Folder ####
$Rollbackdir = "$env:userprofile\MS\WAM_Disconnect\Rollback"
If(!(test-path $rollbackdir)) {New-Item -ItemType Directory -Force -Path $rollbackdir}
 
#### Backup WokplaceJoin Registry Key ####
$WorkplaceJoin = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\WorkplaceJoin"
$RegCheckWPJ = Test-Path $WorkplaceJoin
If ($RegCheckWPJ -eq "True") {Get-ChildItem -path $WorkplaceJoin -Recurse | Export-CliXML "$Rollbackdir\WorkplaceJoin_$(get-date -f dd-MM-yyyy_HH-mm-ss).reg"}
 
#### Check if Reg Key Exists and Remove ####
$RegPath1 = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\WorkplaceJoin\JoinInfo"
$RegPath2 = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\WorkplaceJoin\TenantInfo"
$RegCheck1 = Test-Path $RegPath1
If ($RegCheck1 -eq "True") {Remove-Item -path $RegPath1 -Recurse}
$RegCheck2 = Test-Path $RegPath2
If ($RegCheck2 -eq "True") {Remove-Item -path $RegPath2 -Recurse}
 
#### Backup Organization Certificate and Remove ####
$OrgCert = Get-ChildItem Cert:\CurrentUser\My\ -Recurse | where{$_.Issuer -like "*organization*"}
If ($OrgCert -ne $null) {
    $i=0
    ForEach ($c in $OrgCert) {
       Export-Certificate -Cert $c -FilePath "$Rollbackdir\OrgCert_$(get-date -f dd-MM-yyyy_HH-mm-ss)$i.cer"
       $i++
       $c | Remove-Item
    }
}
 
#### Backup and Remove User Appdata Folder ####
[String] ${stUserDomain},[String] ${stUserAccount} = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\")
Copy-Item -Path "C:\Users\${stUserAccount}\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy" -Recurse -Destination "$Rollbackdir\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy_$(get-date -f dd-MM-yyyy_HH-mm-ss)" -Container
Remove-Item –Path "C:\Users\${stUserAccount}\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\*" -Exclude "RoamingState" -Force -Recurse
 
#### Confirmation Script Completed ####
Echo "MS WAM Disconnect Script V1.5 Completed for $stUserAccount on the $stUserDomain Domain" > "$Env:UserProfile\MS\WAM_Disconnect\WAM_Disconnect_Complete_V1.5_$stUserAccount.txt"