[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

$windowsTerminalDirectory = Get-ChildItem "$Home\AppData\Local\Packages" -Directory -Filter '*WindowsTerminal*'
$windowsTerminalSettingsPath = Join-Path $windowsTerminalDirectory 'LocalState\settings.json'

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$url = "$rootUrl/WindowsTerminal/settings.json"

[PSCustomObject]@{
  Url         = $url
  Destination = $windowsTerminalSettingsPath
}
