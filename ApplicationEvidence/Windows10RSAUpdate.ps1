#Check if Update 3097877 6.1.1.1 is installed
$LogFile =  "$env:WinDir\AppLog\$($MyInvocation.MyCommand.Name).Log"
"Running in $env:userName Context" | Out-File -FilePath $LogFile -Append
$Updates = & dism.exe /Online /get-packages | Select-String -SimpleMatch "RemoteServerAdministrationTools" -Context 4 
If ($?) {
    "DISM Success" | Out-File -FilePath $LogFile -Append
} Else {
    "Error in DISM Command" | Out-File -FilePath $LogFile -Append
}
$Updates | ForEach-Object {
    [PSCustomObject]@{
        'KBArticle' = $_.Line.Split("_") | Select-Object -Last 1 | %{$_.TrimStart('Package Identity : ') -split "~" | Select-Object -First 1};
        'Version' = $_.Line.Split("~") | Select-Object -Last 1;
        'State' = $_.Context.PostContext[0].Split(":")[1].TrimStart(" ");
        'Release' = $_.Context.PostContext[1].Split(":")[1].TrimStart(" ");
        'InstallTime' = $_.Context.PostContext[2].Split(":",2)[1].TrimStart(" ");                   
    }
}
"$([int]$Updates.Count) found" | Out-File -FilePath $LogFile -Append
Switch ($Updates.State) {
    'Install Pending' {<#don't output anything as we are not installed#>}
    'Installed' {$True}
    Default {}
}