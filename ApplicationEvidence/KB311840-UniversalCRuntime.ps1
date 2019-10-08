#Check if Update 3097877 6.1.1.1 is installed
$KBArticle = 'KB3118401'
$Updates = & dism.exe /Online /get-packages | Select-String -SimpleMatch "$KBArticle" -Context 4 | ForEach-Object {
    [PSCustomObject]@{
        'KBArticle' = $_.Line.Split("_") | Select-Object -Last 1 | %{$_.TrimStart('Package Identity : ') -split "~" | Select-Object -First 1};
        'Version' = $_.Line.Split("~") | Select-Object -Last 1;
        'State' = $_.Context.PostContext[0].Split(":")[1].TrimStart(" ");
        'Release' = $_.Context.PostContext[1].Split(":")[1].TrimStart(" ");
        'InstallTime' = $_.Context.PostContext[2].Split(":",2)[1].TrimStart(" ");                   
    }
}

If ($Updates.State -eq 'Installed') {
    $True
}