$Compliance = $True
$SophosServices = "Sophos AutoUpdate Service",
    "Sophos Agent",
    "Sophos Message Router",
    "Sophos Web Control Service",
    "Sophos System Protection Service",
    "sophosssp",
    "SAVService",
    "SAVAdminService",
    "swi_service",
    "swi_update_64",
    "swi_filter"
    
$SophosServices | %{
    $Service = Get-Service -Name $_ -ErrorAction SilentlyContinue
    If ($Service) {
        If ($Service.StartType -ne 'Disabled') {
            $Compliance = $false
        }
    }
}

return $Compliance