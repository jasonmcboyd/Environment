# Install

`Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')`

# Add Environment Settings Source

`choco sources add -n environment -u <username> -p <azure-devops-pat> -s <azure-devops-feed>`

- Replace the end of the Azure DevOps feed url `v3/index.json` with `v2`.
- The Azure DevOps PAT must have read permissions for the **Packaging** scope.

# Packages

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
- environment-vim-config
- environment-windows-terminal-settings
- fiddler
- git
- googlechrome
- gsudo
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
- sysinternals
- terraform
- visualstudio2019community
- visualstudio2022community
- vscode
- wsl2
