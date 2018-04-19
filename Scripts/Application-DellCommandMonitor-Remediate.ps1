$Global:logFile = "$env:WinDir\AppLog\Application-DellCommandMonitor-Remediate.ps1.log"
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}

function Set-MSIRebootSuppress {
    [CmdLetBinding()]
    Param($MSICode,$MSIPath)

    $MSIOPENDATABASEMODEDIRECT = 2 # Setup const mode of DB opening.
    $MSI = new-object -ComObject WindowsInstaller.Installer
    If ($MSICode) {
        $MSIPath = $MSI.ProductInfo($MSICode,"LocalPackage")
    }
    logMsg "Opening MSI $MSIPath"
    $database = $MSI.GetType().InvokeMember(
        "OpenDatabase",
        "InvokeMethod",
        $Null,
        $MSI,
        @("$($MSIPath.ToString())", $MSIOPENDATABASEMODEDIRECT)
    )
    $Query = "Select Property,Value From Property WHERE Property = 'REBOOT'"
    logMsg "Executing query: $Query"
    $View = $database.GetType().InvokeMember(
        "OpenView",
        "InvokeMethod",
        $Null,
        $database,
        ($Query)
    )
    $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)

    $record = $View.GetType().InvokeMember(
        "Fetch",
        "InvokeMethod",
        $Null,
        $View,
        $Null
    )
    $msi_props = @{}
    while ($record -ne $null) {
        $prop_name = $record.GetType().InvokeMember("StringData", "GetProperty", $Null, $record, 1)
        $prop_value = $record.GetType().InvokeMember("StringData", "GetProperty", $Null, $record, 2)
        $msi_props[$prop_name] = $prop_value
        If ($prop_name -eq 'REBOOT' -and $prop_value -ne 'ReallySuppress') {
            logMsg "Current REBOOT Setting is $prop_value. Updating"
            $record.StringData(2) = 'ReallySuppress'
            $View.GetType().InvokeMember("Modify","InvokeMethod",$Null,$View,@(2,$record))
        }        
        
        $record = $View.GetType().InvokeMember(
            "Fetch",
            "InvokeMethod",
            $Null,
            $View,
            $Null
        )
    }
    If ($msi_props.count -eq 0) {
        # Insert Into
        $Insert = "INSERT INTO Property (Property,Value) VALUES('REBOOT','ReallySuppress')"
        logMsg "No Reboot properties found. Running insert command."
        $View = $database.GetType().InvokeMember(
            "OpenView",
            "InvokeMethod",
            $Null,
            $database,
            ($Insert)
        )
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null)
        $View.GetType().InvokeMember("Close", "InvokeMethod", $Null, $View, $Null)
        $database.GetType().InvokeMember(
            "Commit",
            "InvokeMethod",
            $Null,
            $database,
            $Null
        )
    } else {
        $View.GetType().InvokeMember("Close", "InvokeMethod", $Null, $View, $Null)
        $database.GetType().InvokeMember(
            "Commit",
            "InvokeMethod",
            $Null,
            $database,
            $Null
        )
    }

    logMsg "Closing off com objects"
    $database = $null
    $View = $null
    $record = $null
    $msi_props = $null
    $MSI = $null
    [System.GC]::Collect()
}

function Add-MSISource {
    [CmdLetBinding()]
    Param([Parameter(Mandatory=$True)]$ProductName)



}

# Get ARP Entry
$ARPEntry = get-childitem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ | ?{(Get-ItemProperty -Path $_.PSPath -Name DisplayName -EA SilentlyContinue).DisplayName -match 'Dell Command | Monitor'}
If (-Not $ARPEntry) {
    #  If the Add remove programs entry doesn't exist. This kinda can't happen.
    logMsg "Unable to find Dell Command | Monitor ARP Entry. Exiting with an error"
    Write-Error "Unable to find Dell Command | Monitor ARP Entry" -ErrorAction Stop
}

# After that, we know it's installed. Lets repair the MSI
logMsg "Setting MSI to suppress reboots"
Set-MSIRebootSuppress -MSICode $ARPEntry.PSChildName
# Upate MSI Source

logMsg "Starting repair process. Command:"
logMsg "msiexec.exe /fam $($ARPEntry.PSChildName) /qn REBOOT=REALLYSUPPRESS"
$Result = Start-Process -FilePath msiexec.exe -ArgumentList "/fam $($ARPEntry.PSChildName) /qn REBOOT=REALLYSUPPRESS" -Wait -PassThru
logMsg "ExitCode: $($Result.ExitCode)"