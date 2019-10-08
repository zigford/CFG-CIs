function Get-DellBiosSession {
    Param($CimSession,$ComputerName)
    If ($Script:CimSession) { return $Script:CimSession }
    If ($ComputerName) { return New-CimSession -ComputerName $ComputerName }
    If ($CimSession) { return $CimSession }
    return New-CimSession
}

function Remove-DellBiosSession {
    Param($CimSession,$ComputerName)
    If ($ComputerName -or $CimSession.ComputerName -eq 'localhost') {
        $CimSession | Remove-CimSession
    }
}

function Get-DellBiosEnumClass {
    Param([CimSession]$CimSession)
    $Names = Get-CimInstance -CimSession:$CimSession `
        -NameSpace root\dcim\sysman -ClassName __Namespace
    if ('biosattributes' -in $Names.Name) {
        return @{
            NameSpace = 'root\dcim\sysman\biosattributes'
            ClassName = 'EnumerationAttribute'
        }
    } else {
        return @{
            NameSpace = 'root\dcim\sysman'
            ClassName = 'DCIM_BIOSEnumeration'
        }
    }
}

function Get-DellBiosAttributeList {
    Param([CimSession]$CimSession)
    If (-Not $Script:AttributeList) {
        Try {
            Write-Debug "Reading attribute list from CimSession"
            $CimArgs = Get-DellBiosEnumClass -CimSession:$CimSession
            $Script:AttributeList = Get-CimInstance @CimArgs |
                Select-Object -Expand AttributeName |
                Sort-Object
        } catch {
            Write-Error "DCIM not supported"
        }
    }
    $Script:AttributeList
}

function Get-DellBiosAttribute {
    <#
    .SYNOPSIS
        Display bios attributes using Dell Command | Monitor
    .DESCRIPTION
        List available bios attributes which can be set, or display a single attribute, its current value and possible values
    .PARAMETER ListAttributes
        Return a list of attributes available on the current system
    .PARAMETER AttributeName
        Return the current value of the attribute, it's possible values and their descriptions. AttributeName is case sensitive.
    .EXAMPLE
        PS> Get-BiosAttribue -AttributeName "Auto on Tuesday"

        AttributeName             : Auto on Tuesday
        CurrentSettingDescription : Disable
        CurrentValue              : {2}
        PossibleValuesDescription : {Enable, Disable}
        PossibleValues            : {1, 2}
    .EXAMPLE
        PS> Get-BiosAttribue -ListAvaialable

        AC Power Recovery Mode
        Admin Setup Lockout
        Advanced Battery Charging Mode
        Always Allow Dell Docks
        Attempt Legacy Boot
        Auto On
    .NOTES
        Author: Jesse Harris
        Version: 1.0
    .LINK
        https://github.com/zigford/DellCommandMonitor
    #>
    [CmdLetBinding(DefaultParameterSetName='Get')]
    Param(
        [parameter(ParameterSetName='Get',Mandatory=$True)]
        [parameter(Position=0)]
        $AttributeName,
        [Parameter(ParameterSetName='List')][Switch]$ListAttributes,
        [CimSession]$CimSession,
        [String]$ComputerName
    )

    Begin{
        $CimSession = Get-DellBiosSession -CimSession:$CimSession `
            -ComputerName:$ComputerName
        $CimArgs = Get-DellBiosEnumClass -CimSession:$CimSession
    }
    Process {
        If ($ListAttributes) {
            Get-DellBiosAttributeList -CimSession:$CimSession
        } else {
            $CimArgs.Query = "Select * from $($CimArgs.ClassName) where " `
                + "AttributeName = '$AttributeName'"
            $CimArgs.Remove('ClassName')
            $AttributeValue = Get-CimInstance @CimArgs -CimSession:$CimSession
            If (-Not $AttributeValue) {
                throw "No such attribute. Use -Listavailable to see valid options"
            }
            If ($AttributeValue.DisplayName) {
                $CurrentValue = $AttributeValue.CurrentValue
                $PossibleValues = $AttributeValue.PossibleValue
            } else {
                $PossibleValues = $AttributeValue.PossibleValuesDescription
                $CurrentValue = Get-DellBiosValue $AttributeValue
            }
            [PSCustomObject]@{
                'AttributeName' = $AttributeValue.AttributeName
                'CurrentValue' = $CurrentValue
                'PossibleValues' = $PossibleValues
            }
        }
    }
    End {
        Remove-DellBiosSession -CimSession:$CimSession `
            -ComputerName:$ComputerName
    }
}

If (Get-DellBiosAttribute -ListAttributes | Where-Object {$_ -match 'LidSwitch'}) {
    $CurrentValue = (Get-DellBiosAttribute -AttributeName 'LidSwitch').CurrentValue
    If ($CurrentValue -eq 'Disabled') {
        return $False
    } else {
        return $True
    }
}
return $True
