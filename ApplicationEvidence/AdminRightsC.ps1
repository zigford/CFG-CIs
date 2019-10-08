$AdminRightsC = "$env:systemdrive\ProgramData\USC\AdminRightsC.exe"
If (Test-Path -Path $AdminRightsC) {
    $ProcessResult = Start-Process -FilePath $AdminRightsC -ArgumentList "TestCurrentUser" -Wait -PassThru
    If ($ProcessResult.ExitCode -eq 0) {
        Write-Output "User is a local administrator"
    }
}