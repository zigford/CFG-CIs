$Joined = $False

$WorkplaceJoin = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\WorkplaceJoin'
$InfoKeys = 'JoinInfo','TenantInfo'

ForEach ($Key in $InfoKeys) {
    If (Test-Path -Path "$WorkplaceJoin\$Key" -EA SilentlyContinue) {
        $Joined = $True
    }
}

return $Joined