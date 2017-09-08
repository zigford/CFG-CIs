[cmdletbinding()]
Param()
$ErrorActionPreference =  "Stop"
$HasNoAssignedDTs = $True
[int] $countMissingDTs = 0
try {
    $Applications = gwmi -namespace root\ccm\clientsdk -query "select * from ccm_application"
} catch {
    exit 1
}
 
$AppsTotal =  $Applications.Length
foreach ($App in $Applications ) {
    $AppDT =  [wmi] $App.__Path
    Write-Verbose "$($App.Name) DT: $($AppDT.AppDTs.Name)"
    if ($AppDT.AppDTs.Name.Length  -eq 0) {
        $countMissingDTs =  $countMissingDTs + 1
    } Else {
        $HasNoAssignedDTs = $False
    }
}
 
$HasNoAssignedDTs