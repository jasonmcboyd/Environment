# Install

`Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')`

# Add Environment Settings Source

`choco sources add -n environment -u <username> -p <azure-devops-pat> -s <azure-devops-feed>`

- Replace the end of the Azure DevOps feed url `v3/index.json` with `v2`.
- The Azure DevOps PAT must have read permissions for the **Packaging** scope.

# Updating The Environment Settings Source PAT

As far as I can tell there is no way to simply update the password for the source. You must first remove the source (command below) and then rerun the above command to readd the source with the new PAT.

`choco sources remove --name environment`

# Packages

Install sysinternals apps individually rather than using the `sysinternals` Chocolatey package so that the app shims are generated and added to Chocolatey bin folder which is included in the `path` environment variable.

- azure-cli
- beyondcompare
- brave
- cascadia-code-nerd-font
- citrix-workspace
- docker-desktop
- DotNet4.5.2
- dotnetcore-sdk
- dotnetfx
- environment-powershell-core-profile
- environment-starship-config
- environment-vim-config
- environment-windows-terminal-settings
- fiddler
- git
- googlechrome
- gsudo
- kubernetes-cli
- linqpad5
- linqpad6
- microsoft-windows-terminal
- microsoftazurestorageexplorer
- notepadplusplus
- powershell-core
- powertoys
- procexp
- procmon
- starship
- terraform
- visualstudio2019community
- visualstudio2022community
- vscode
- wsl2
