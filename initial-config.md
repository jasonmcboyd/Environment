Run PowerShell as admin

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Use SkipNetworkProfileCheck switch to skip network profile check. This can be usefule
# when you are using a VM with a network profile that is not connected to the network.
Enable-PSRemoting -Force
# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')

Update-Help

# Out of the box PowerShell comes with PackageManagement version 1.0.0.1. We want
# to install the latest (1.4.7 as of now).
Install-Module PackageManagement -Force

# Remove the old module (not sure about this step).
rmdir 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1' -Force -Recurse

# Configure system settings.
Invoke-WebRequest https://raw.githubusercontent.com/jasonmcboyd/Environment/master/DSC/SystemConfiguration.ps1 -OutFile SystemConfiguration.ps1
./SystemConfiguration.ps1
Start-DscConfiguration ./System -Wait

# Configure user settings.
Invoke-WebRequest https://raw.githubusercontent.com/jasonmcboyd/Environment/master/DSC/UserConfiguration.ps1 -OutFile UserConfiguration.ps1
$creds = Get-Credential
./UserConfiguration.ps1 -Credential $creds
Start-DscConfiguration ./User -Wait

# Create the local secret store.
Register-SecretVault -ModuleName Microsoft.PowerShell.SecretStore -Name LocalStore
```
