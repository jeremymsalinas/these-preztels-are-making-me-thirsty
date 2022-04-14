$cred = Get-Credential
$id = Read-Host "Please enter the asset ID"
$computerName = "some naming convention" + $id
Add-Computer -DomainName 'domain' -Server domain\server -NewName $computerName -OUPath "OU" -Credential $cred