$xml =[xml](get-content 'c:\windows\labstats.conf')
if ($xml.config.host -eq 'sdapp01.usc.edu.au') {$true} else {$false}