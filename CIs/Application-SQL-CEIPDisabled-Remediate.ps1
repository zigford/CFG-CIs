[CmdLetBinding(SupportsShouldProcess)]
Param($ComplianceValue)

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
            Write-Verbose ("Instance $InstanceVerAndName check $Value" +
                           " enabled: $Result")
        } else {
            # if unspecifed value, check both and return
            # true if either are enabled and false if both are
            # disabled
            $Result = ($CPEKey.GetValue('EnableErrorReporting') -eq 1 -or
                       $CPEKey.GetValue('CustomerFeedback') -eq 1)
                       Write-Verbose ("Instance $InstanceVerAndName check " +
                                      "error and ceip enabled: $result")
        }
        return $Result
    }
}

# Function to return true of errorreporting or customer
# feedback is enabled for a given instance
function Disable-SQLInstanceCPEValue {
    [CmdLetBinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Mandatory=$True,
            Position=0
        )]$InstanceVerAndName,
        [ValidateSet(
            'EnableErrorReporting',
            'CustomerFeedback'
        )][Parameter(Mandatory=$True)]$Value
    )
    Process {
        $SetItemPropertyArgs = @{
            Path = "$SQLKEYPATH\$InstanceVerAndName\CPE"
            Name = $Value
            Value = 0
        }
        Set-ItemProperty @SetItemPropertyArgs
    }
}

# gather the instance names
$Instances = Get-MSSQLInstanceNames | Get-MSSQLInstanceVerAndName

# Logic for checking to return for CI
# We want both instances to return false
$Instances | ForEach-Object {
    ForEach ($Value in 'EnableErrorReporting','CustomerFeedback') {
        If (Test-SQLInstanceCPEValueEnabled $_ -Value $Value) {
            Disable-SQLInstanceCPEValue $_ -Value $Value
        }
    }
}
