$FilePath = "$($env:windir)\system32\Macromed\Flash\mms.cfg"

If (Test-Path -Path $FilePath) {
    $FileContent = Get-Content -Path $FilePath
    $FlashSettings = $FileContent | ForEach-Object { 
        [PSCustomObject]@{$_.Split("=")[0] = $_.Split("=")[1]}
    }
    If ($FlashSettings.AutoUpdateDisable -eq 1) {
        $True
    } Else {
        $False
    }
} Else {
    $False
}