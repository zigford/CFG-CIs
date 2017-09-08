$xml =[xml](get-content 'c:\windows\labstats.conf')
$xml.config.host = 'sdapp01.usc.edu.au'
$xml.save('c:\windows\labstats.conf')