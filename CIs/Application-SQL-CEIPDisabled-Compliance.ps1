[CmdLetBinding()]
Param()

# Setup constants

$SQLKEYPATH = 'HKLM:\Software\Microsoft\Microsoft SQL Server'
$SQLINSTANCEKEY = Get-Item "$SQLKEYPATH\Instance Names\SQL"

# Function to return instance names
function Get-MSSQLInstanceNames {
    [CmdLetBinding()]
    Param()
    $SQLINSTANCEKEY.GetValueNames()
}

# Function to return instance ver and name.
# used as part of reg key path where errorreporting
# and customerfeedback settings are stored in reg.
function Get-MSSQLInstanceVerAndName {
    [CmdLetBinding()]
    Param([Parameter(ValueFromPipeline=$True)]$InstanceName)
    Process {
        $SQLINSTANCEKEY.GetValue($InstanceName)
    }
}

# Function to return true of errorreporting or customer
# feedback is enabled for a given instance
function Test-SQLInstanceCPEValueEnabled {
    [CmdLetBinding()]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=0
        )]$InstanceVerAndName,
        [ValidateSet(
            'EnableErrorReporting',
            'CustomerFeedback'
        )]$Value
    )
    Process {
        $CPEKey = Get-Item "$SQLKEYPATH\$InstanceVerAndName\CPE"
        If ($Value) {
            $Result = $CPEKey.GetValue($Value) -eq 1
        } else {
            # if unspecifed value, check both and return
            # true if either are enabled and false if both are
            # disabled
            $Result = ($CPEKey.GetValue('EnableErrorReporting') -eq 1 -or
                       $CPEKey.GetValue('CustomerFeedback') -eq 1)
                       Write-Verbose "Instance $InstanceVerAndName check error and ceip $result"
        }
        return $Result
    }
}

# gather the instance names
$Instances = Get-MSSQLInstanceNames | Get-MSSQLInstanceVerAndName

# Logic for checking to return for CI
# We want both instances to return false
$Compliant = $True
$Instances | ForEach-Object {
    If (Test-SQLInstanceCPEValueEnabled $_) {
        $Compliant = $False
    }
}

# return complane
$Compliant
