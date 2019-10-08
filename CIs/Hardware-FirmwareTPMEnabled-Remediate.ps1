$BiosPassword = 'PasswordHere'
Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BIOSService | Invoke-CimMethod -MethodName SetBIOSAttributes -Arguments @{AttributeName=@("Trusted Platform Module");AttributeValue=@("1");AuthorizationToken="$BiosPassword"} | Out-Null
Get-CimInstance -Namespace root\dcim\sysman -ClassName DCIM_BIOSService | Invoke-CimMethod -MethodName SetBIOSAttributes -Arguments @{AttributeName=@("Trusted Platform Module Activation");AttributeValue=@("2");AuthorizationToken="$BiosPassword"} | Out-Null
