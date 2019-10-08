[CmdLetBinding()]
Param($Run)
$BiosPassword = 'PasswordHere'

function Get-BiosAttribute {
    [CmdLetBinding()]
    Param(
        [parameter(ParameterSetName='Get')]
        [ValidateScript(
            {
                $_ -in (Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BiosEnumeration).AttributeName
            }
        )]
        $AttributeName,
        [Parameter(ParameterSetName='List')][Switch]$ListAttributes
    )

    Begin {
        # Test if DCIM support exists
        Try {
            Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BiosEnumeration | Out-Null
        } catch {
            Write-Error "DCIM not supported"
        }
    }

    Process {
        If ($ListAttributes) {
            Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BiosEnumeration | Select-Object -ExpandProperty AttributeName | Sort-Object
        } else {
            $AttributeValue = Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BiosEnumeration | Where-Object {$_.AttributeName -eq $AttributeName} 
            $CurrentValue = $AttributeValue.CurrentValue
            $PossibleValueIndex = for ($i=0;$i -lt $AttributeValue.PossibleValues.Count;$i++) { If ($AttributeValue.PossibleValues[$i] -eq $CurrentValue) {$i}}
            $ValueDescription = $AttributeValue.PossibleValuesDescription[$PossibleValueIndex]
            [PSCustomObject]@{
                'AttributeName' = $AttributeName
                'CurrentSettingDescription' = $ValueDescription
                'CurrentValue' = $CurrentValue
                'PossibleValuesDescription' = $AttributeValue.PossibleValuesDescription
                'PossibleValues' = $AttributeValue.PossibleValues
            }
        }
    }
}

function Set-BiosAttribute {
    [CmdLetBinding()]
    Param(
        [Parameter(Mandatory=$True)][ValidateScript({$_ -in (Get-BiosAttribute -ListAttributes)})][string]$AttributeName,
        [Parameter(Mandatory=$True)]$ValueName,
        $BiosPassword
    )
    Begin {
        #Check if the value is a possible value
        $CurrentAttribute = Get-BiosAttribute -AttributeName $AttributeName
        if ($ValueName -notin $CurrentAttribute.PossibleValuesDescription) {
            Write-Error "Value falls outside of possible values. Can only be one of: $($CurrentAttribute.PossibleValuesDescription)"
        }
    }

    Process {
        # Calculate what the Value number will be.
        for ($i=0;$i -lt $CurrentAttribute.PossibleValuesDescription.Count;$i++) {
            If ($CurrentAttribute.PossibleValuesDescription[$i] -eq $ValueName) {
                $SetToValue = $CurrentAttribute.PossibleValues[$i]
            }
        }
        Write-Verbose "Setting Attribute $AttributeName to value $SetToValue"
        $BiosService = Get-WMIObject -Namespace root\dcim\sysman -Class DCIM_BiosService
        $Result = $BiosService.SetBiosAttributes($null,$null,"$AttributeName","$SetToValue",$BiosPassword)
        If ($Result.SetResult[0] -eq 0) {
            Write-Verbose "Succesfully updated attribute value"
        } else {
            Write-Error "Failed to update attribute value"
        }
    }
}

$WakeOnLanSetting = Get-BiosAttribute -AttributeName 'Wake-On-LAN'
If ($WakeOnLanSetting.CurrentSetting -ne 'LAN') {
    # Not compliant
    return $False
} else {
    return $True
}