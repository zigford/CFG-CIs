#Compliance Check for EndNoteX7 Word Addon
$KeyPath = 'HKLM:\Software\Wow6432Node\Microsoft\Office\Word\Addins\EndNote.WordAddin.Connect'
If (-Not (Test-Path -Path $KeyPath)) {
    $False
} Else {
    $True
}