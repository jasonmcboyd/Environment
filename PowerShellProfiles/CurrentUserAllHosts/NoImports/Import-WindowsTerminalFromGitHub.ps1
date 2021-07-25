[CmdletBinding()]
param (
    [string]
    $Branch = 'master',

    $RemoteFileHashes
)

$userHome = $HOME
$windowsTerminalDirectory = Get-ChildItem "$userHome\AppData\Local\Packages" -Directory -Filter '*WindowsTerminal*'
$windowsTerminalSettingsPath = Join-Path $windowsTerminalDirectory 'LocalState\settings.json'

Write-Debug "windowsTerminalSettingsPath: $windowsTerminalSettingsPath"

if (!(Test-Path $windowsTerminalSettingsPath)) {
    throw "Windows Terminal settings not found."
}

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$url = "$rootUrl/WindowsTerminal/settings.json"

$hashesMatch =
    & "$PSScriptRoot/Compare-FileHash.ps1" `
        -Branch $Branch `
        -FilePath $windowsTerminalSettingsPath `
        -GitHubUrl $url `
        -RemoteFileHashes $RemoteFileHashes

if (!$hashesMatch) {
    Write-Verbose "Downloading $url"
    Invoke-WebRequest $url -OutFile "$windowsTerminalSettingsPath"
}
