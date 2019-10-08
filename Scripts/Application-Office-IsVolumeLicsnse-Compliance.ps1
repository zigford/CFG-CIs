# Test if the install office IS MSI OR Vol C2R
# Default answer is $False
$returnValue = $False

$C2RRegKeyPath = 'HKLM:\Software\Microsoft\Office\ClickToRun\Configuration'
$ProductIDsValue = 'ProductReleaseIds'
$ProductToCheck = 'ProPlus2019Volume'

# First check Vol License C2R

$C2RRegKeyExists = Test-Path -Path $C2RRegKeyPath
If ($C2RRegKeyExists) {
    $C2RRegKeyProperties = Get-ItemProperty -Path $C2RRegKeyPath
    If ($C2RRegKeyProperties -ne $Null) {
        $ProductIDs = Get-ItemPropertyValue -Path $C2RRegKeyPath `
            -Name $ProductIDsValue
        If ($ProductIds -match $ProductToCheck) {
            $returnValue = $True
        }
    }
}

# Now check for MSI

$ProductCode = '{90160000-0011-0000-0000-0000000FF1CE}'
'Software','Software\Wow6432Node' | ForEach-Object {
    $UninstallKey = "HKLM:\$_\Microsoft\Windows\CurrentVersion\Uninstall"
    If (Test-Path -Path "$UninstallKey\$ProductCode") {
        $returnValue = $True
    }
}

return $returnValue
