# Install

Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')

# Add Environment Settings Source

`choco sources add -n environment -u <username> -p <azure-devops-pat> -s <azure-devops-feed>`

Remember to replace the end of the Azure DevOps feed url `v3/index.json` with `v2`.
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
- linqpad5
- linqpad6
- microsoft-windows-terminal
- notepadplusplus
- powershell-core
- procexp
- procmon
- starship
- sysinternals
- terraform
- visualstudio2019community
- vscode
- wsl2
