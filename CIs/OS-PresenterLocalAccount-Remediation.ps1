# Remediation script to create the presentation local account and/or set the password
# Define logfile
$Global:logFile = "$env:WinDir\AppLog\OS-PresenterLocalAccount-Remediation.ps1.log"

# Logging function
function logMsg {
    [CmdLetBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True
        )]$Message,$logFile=$Global:logFile
    )
    "$(Get-Date): $Message" | Out-File -FilePath $logFile -Append
}

# Define variables
$computername = $env:computername
logMsg "Computer Name = $computername"
$localaccountname = "AV-$env:computername"
logMsg "Local Account Name = $localaccountname"
$Password = "PasswordHere"
$registryPath = "HKLM:\Software\USC\AVLocalAccountInfo"
logMsg "Registry path = $registryPath"
$Name = "Version"
$value = "1"
logMsg "Password version = $value"
# $value is the version of the AVLocalAccount password - increment this to match the compliance script when updating the password.
# Password versions:
# 1 = PasswordHere

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
logMsg "Password converted to secure string"

$localExists = (get-localuser -Name $localaccountname)

# Check see if the local account exists, if not create it and then set the password.
If (-Not $LocalExists) {
    #  If the local presentation account does not exist then create it
    logMsg "Local presentation acccount does not exist - creating one and setting password"
    New-LocalUser -Name $localaccountname -AccountNeverExpires -Description "Local account for presentation use" -Password $SecurePassword -PasswordNeverExpires -UserMayNotChangePassword
    logMsg "Local presentation acccount $localaccountname created and password set."
} else {
    #  If the local presentation account does exist then we need to just set the password.
    logMsg "Local presentation acccount $localaccountname does exist - setting the password"
    Set-LocalUser -Name $localaccountname -Password $SecurePassword -PasswordNeverExpires $true -UserMayChangePassword $true
    logMsg "Local presentation acccount $localaccountname password set."
    }

# Write a regsitry value to allow for check of password currency
If (!(Test-Path $registryPath)) {
    # If the registry key does not exist create it and add the version property and value
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
    logMsg "Registry key $Name created at $registrypath."
} else {
    # The registry key already exists so just update the value
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
    logMsg "Registry key $Name updated to $value."
}