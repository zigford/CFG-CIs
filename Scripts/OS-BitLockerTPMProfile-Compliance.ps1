$DesiredPCRs = 7,11

function Get-PCRFromTPM {
    [CmdLetBinding()]
    Param()
    Begin {}
    Process {
        $EXEPath = "$env:SystemRoot\System32\manage-bde.exe"
        $Args = "-protectors -get $env:SystemDrive"
        $ManageBDEOutPut = Invoke-Expression "$EXEPath $Args"
        $PCRString = $ManageBDEOutPut | Select-String -Pattern '^\s.*PCR\sValidation\sProfile.*$' -Context 0,1
        $PCRs = $PCRString.Context.PostContext[0].TrimStart().Split(',') | ForEach-Object {
            [int]$_.Trim()
        }
        $PCRs
    }
}

If (Compare-Object -ReferenceObject $DesiredPCRs -DifferenceObject (Get-PCRFromTPM)) {
    $False
} else {
    $True
}