# Initial Config

Run PowerShell as admin. **It is best to do this with Windows PowerShell**. Trying to do this with Pwsh can cause issues with conflicting PackageManagement versions.

### Set Script Execution Policy

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

### Enable PSRemoting

Aside from having this enabled being handy, **this must be enabled for DSC to work**.

This cannot be done by default on a public network. When setting up a machine for the first time, Windows defaults new network connections to public. It must be remembered to set the network to private after the initial connection.

`SkipNetworkProfileCheck` switch to skip network profile check. This can be useful
when I are using a VM with a network profile that is not connected to the network.

```powershell
Enable-PSRemoting -Force
```

### Install Chocolatey

```powershell
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
```

### Update PowerShell Help

Not strictly necessary but nice to have. Several modules fail to update their help. Maybe I will look into it later.

```powershell
Update-Help
```

### Update PackageManagement Module

Out of the box PowerShell comes with PackageManagement version 1.0.0.1. I want to install the latest (1.4.7 as of now). Once the latest version is installed, the old version can be removed. In fact, I think it has to be removed to avoid issues with DSC later on. However, the default installed version does not show up in `Get-InstalledModule`. So it cannot be removed using `Uninstall-Module`. Instead, I just delete the folder.

```powershell
Install-Module PackageManagement -Force

rmdir 'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.0.0.1' -Force -Recurse
```

### Configure System Wide Settings With PowerShell DSC

Download the DSC configuration file from this repo.

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/jasonmcboyd/Environment/master/DSC/SystemConfiguration.ps1 -OutFile SystemConfiguration.ps1
```

Run the configuration. This will create a MOF file at ./System/localhost.mof.

```powershell
./SystemConfiguration.ps1
```

Optional, test the DSC state.

```powershell
Test-DscConfiguration ./System
```

Apply the configuration.

```powershell
Start-DscConfiguration ./System -Wait
```

### Configure User Settings With PowerShell DSC

Download the DSC configuration file from this repo.

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/jasonmcboyd/Environment/master/DSC/UserConfiguration.ps1 -OutFile UserConfiguration.ps1
```
Run the configuration. This will create a MOF file at ./User/localhost.mof. This will require an Azure DevOps PAT to access the Azure DevOps environment package feed. The PAT must have read permissions for the **Packaging** scope. Also, the DSC engine will be running as admin, but we need to target the user for the user config. Use the `Credential` parameter to run as the target user.

The mof file will store the PAT and the credentials in plain text. This repo is configured for Git to ignore mof files, but care should still be taken to delete the mof file after the configuration is applied.

```powershell
$creds = Get-Credential
$azurePat = Get-Credential
./UserConfiguration.ps1 -Credential $creds -AzureDevOpsPAT $azurePat
```

Optional, test the DSC state.

```powershell
Test-DscConfiguration ./User
```

Apply the configuration.

```powershell
Start-DscConfiguration ./User -Wait
```

### Create Local PowerShell Secret Store

This will create a local secret store for the current user. The first time a secret is added to the store, the user will be prompted to create a password. This password will be used to encrypt the secrets.

```powershell
Register-SecretVault -ModuleName Microsoft.PowerShell.SecretStore -Name LocalStore
```

### Install Ubuntu For WSL 2

```powershell
wsl --install --distribution Ubuntu
```
