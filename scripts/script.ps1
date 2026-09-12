```powershell
Import-Module ActiveDirectory
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

$TargetOU = "OU=_USERS,DC=mydomain,DC=com"
$TxtPath = "C:\Users\User\Desktop\names.txt"
$Password = ConvertTo-SecureString "SecretPassword1!" -AsPlainText -Force
$Users = Get-Content -Path $TxtPath

foreach ($Line in $Users) {
    if ([string]::IsNullOrWhiteSpace($Line)) { continue }
    $NameParts = $Line -split " "
    $First = $NameParts[0]
    $Last = $NameParts[1]
    $UserLogon = ($First.Substring(0,1) + $Last).ToLower()
    Write-Host "Creating user: $First $Last ($UserLogon)..." -ForegroundColor Yellow
    
    New-ADUser -Name "$First $Last" `
               -GivenName $First `
               -Surname $Last `
               -SamAccountName $UserLogon `
               -UserPrincipalName "$UserLogon@mydomain.com" `
               -Path $TargetOU `
               -AccountPassword $Password `
               -Enabled $true `
               -PasswordNeverExpires $true
}
Write-Host "Bulk provisioning completed successfully!" -ForegroundColor Green
```
