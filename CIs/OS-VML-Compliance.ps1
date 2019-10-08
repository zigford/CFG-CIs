$RegPath = 'HKLM:\SOFTWARE\Classes\CLSID\{10072CEC-8CC1-11D1-986E-00A0C955B42E}\InprocServer32'
If (Test-Path $RegPath) {
    $RegProperties = Get-ItemProperty -Path $RegPath
    If ($RegProperties.'(default)') {
        If ($RegProperties.'(default)' -match 'vgx.dll') {
            $False
            #Reg Path exists and contains vgx.dll
        } Else {
            $True
            #Reg path exists but does not contain vgx.dll
        }
    } Else {
        #Reg Path exists but does not have a default value
        $True
    }
} Else {
    #Reg path does not exist.
    $True
}