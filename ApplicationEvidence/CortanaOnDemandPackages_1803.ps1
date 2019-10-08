#Check if Update 3097877 6.1.1.1 is installed
#$LogFile =  "$env:WinDir\AppLog\$($MyInvocation.MyCommand.Name).Log"
#"Running in $env:userName Context" | Out-File -FilePath $LogFile -Append

$PackagesToCheck = 'Speech-en-au','TextToSpeech-en-au','QuickAssist'

function Get-InstalledPackage {
    [CmdLetBinding()]
    Param([Parameter(ValueFromPipeline=$True)]$Name)

    Begin {
        $AllPackages = Get-WindowsPackage -Online
        if ($?) {
            Write-Verbose "Dism command succeeded"
        } else {
            Write-Error "Unable to complete Dism command"
        }
        $return = $true
    }

    Process {
        # We want to return false if not all are installed
        # So if any don't have a result, set the return object to false
        ForEach ($Package in $PackagesToCheck) {
            if (-Not ($AllPackages | Where-Object { $_.PackageName -match $Name })) {
                $return = $false
            } 
        }
    }

    end {
        return $return
    }
}

$PackagesToCheck | Get-InstalledPackage