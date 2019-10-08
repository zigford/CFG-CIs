#Check if Windows Update is registered as an update source.
$ServiceRegistered = $False

$updateSvc = New-Object -ComObject Microsoft.Update.ServiceManager
$updateSvc.Services | Where-Object { $_.IsDefaultAUService -eq $false -and $_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d" } | ForEach-Object { 
    $ServiceRegistered = $True
}

return $ServiceRegistered