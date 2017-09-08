$MaxSize=100Mb

function Get-WinmgmtsSize {
    [CmdLetBinding()]
    Param()
    Begin {}
    Process {
        $DBPath = "$env:SystemRoot\System32\wbem\Repository\OBJECTS.DATA"
        If (Test-Path -Path $DBPath -EA SilentlyContinue) {
            Get-Item -Path $DBPath | Select-Object -ExpandProperty Length
        } Else {
           $null
        }
    }
}

If ((Get-WinmgmtsSize) -gt $MaxSize) {
    $False
} else {
    $True
}