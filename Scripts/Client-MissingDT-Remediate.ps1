[CmdletBinding()]
Param()
# Machine
$ErrorActionPreference = "Stop"
try {
    [int]$countMissingDTs = 0
    Write-Verbose "Gathering Applications"
    $Applications = Get-WmiObject -namespace root\ccm\clientsdk -query "select * from ccm_application"
    $AppsTotal = $Applications.Length
    $missingIds = @()
    foreach($App in $Applications) {
        Write-Verbose "Testing Deployment Type for $($App.Name)"
        $AppDT = [wmi] $App.__Path
        if($AppDT.AppDTs.Name.Length -eq 0) {
            #Write-Host $($App.Id)
            $missingIds += $App.Id
            $countMissingDTs = $countMissingDTs + 1
        }
    }
    Write-Verbose "$countMissingDTs missing deployment types"
    if ($countMissingDTs -gt 0) {
        Write-Verbose "Gathering Assignments"
        foreach ($appId in $missingIds) {
            $assignments = Get-WmiObject -query "select AssignmentName, AssignmentId, AssignedCIs from CCM_ApplicationCIAssignment" -namespace "ROOT\ccm\policy\Machine"
            if ($assignments -ne $null) {
                foreach ($assignment in $assignments) {
                    $assignedCI = $assignment.AssignedCIs[0]
                    Write-Verbose "Processing Assignment $($assignment.AssignmentName) $($assignment.AssignmentId) $($assignedCI.CI.ID)"
                    $assignedCISplit = ([xml]$assignedCI).CI.ID.Split("/")
                    Write-Verbose $($assignedCISplit[0]+"/"+$assignedCISplit[1].replace("RequiredApplication", "Application"))
                    if ($($assignedCISplit[0]+"/"+$assignedCISplit[1].replace("RequiredApplication", "Application")) -eq $appId) {
                        Write-Verbose "Processing Assignment $($assignment.AssignmentName) $($assignment.AssignmentId)"
                        $sched=([wmi]"root\ccm\Policy\machine\ActualConfig:CCM_Scheduler_ScheduledMessage.ScheduledMessageID='$($assignment.AssignmentId)'");
                        $sched.Triggers=@('SimpleInterval;Minutes=1;MaxRandomDelayMinutes=0');
                        $null = $sched.Put()
                        sleep -milliseconds 3000
                    } else {
                        Write-Verbose "Skip assignment $($assignment.AssignmentName)"
                    }
                }
            } else {
                Write-Verbose "$appId not found"
            }
        }
    }
} catch {
    Write-Verbose $_.Exception
    return $false
}
return $true