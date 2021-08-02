[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

$windowsTerminalDirectory = Get-ChildItem "$Home\AppData\Local\Packages" -Directory -Filter '*WindowsTerminal*'

if (($null -eq $windowsTerminalDirectory) -or !(Test-Path $windowsTerminalDirectory)) {
  Write-Verbose "Windows Terminal does not appear to be installed."
  return
}

$windowsTerminalSettingsPath = Join-Path $windowsTerminalDirectory 'LocalState\settings.json'

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$url = "$rootUrl/WindowsTerminal/settings.json"

[PSCustomObject]@{
  Url         = $url
  Destination = $windowsTerminalSettingsPath
  LineEnding  = "CRLF"
}
