$Installed = $True

If (!(Test-Path -Path C:\Scratch)) { return $Null }

$ACLs = icacls C:\Scratch | ForEach-Object {
    if ($_.Trim() -and $_ -notmatch 'processed') {$_ -replace '^.*?\s+(.*)$','$1'}
}

$CorrectACLs = 'BUILTIN\Users:(Rc,S,RD,AD,X,RA)',
    'CREATOR OWNER:(OI)(IO)(F)',
    'CREATOR OWNER:(CI)(IO)(F)'


# ACL Count should be 6
If ($ACLs.count -ne 6) {
    # don't emit anything
    return $Null
}

$CorrectACLs | %{
    If ($_ -notin $ACLs) {
        return $Null
    }
}

return $Installed