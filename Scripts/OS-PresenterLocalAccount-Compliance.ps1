# Compliance script to see if presentation local account exists
# Define logfile
$Global:logFile = "$env:WinDir\AppLog\OS-PresenterLocalAccount-Compliance.ps1.log"

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


# Convert password to secure string
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
logMsg "Password converted to secure string"

$localExists = (get-localuser -Name $localaccountname)

If (-Not $LocalExists) {
    #  If the local presentation account does not exist. The OS state is non-compliant
    logMsg "Local presentation acccount does not exist. OS is not compliant"
    return $False    
} else {
    #  If the local presentation account does exist and the password version is correct then the OS state is compliant
    logMsg "Local presentation acccount does exist."

    # Grab the password version registry value
    $version =((Get-ItemProperty "HKLM:\SOFTWARE\usc\AVLocalAccountInfo").Version)

    If ($version -eq "1") { # Increment this version number if you want the remediation script to apply a new password
        # If the password version matches the above value then all is good. 
        logMsg "Local presentation acccount password is the correct version."
        logMsg "Local presentation acccount exists and password is correct. OS is compliant."
        return $True
    }
    logMsg "Local presentation acccount exists but the password is not the correct version."
    return $False
    }