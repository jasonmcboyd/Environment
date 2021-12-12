Run as admin

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

Enable-PSRemoting -Force
# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')

Update-Help

# Out of the box PowerShell comes with PackageManagement version 1.0.0.1. We want
# to install the latest (1.4.7 as of now).
Install-Module PackageManagement -Force

# Remove the old module (not sure about this step).
rmdir 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1' -Force -Recurse
```

Start new shell as admin

```powershell
mkdir ~/Dev

choco install git -y

Push-Location "~/Dev"
git clone https://github.com/jasonmcboyd/Environment.git

Push-Location ~/Dev/Environment/Dsc

./SystemConfiguration
Start-DscConfiguration ./System -Wait


$creds = Get-Credential
./UserConfiguration $creds
Start-DscConfiguration ./User -Wait
```
