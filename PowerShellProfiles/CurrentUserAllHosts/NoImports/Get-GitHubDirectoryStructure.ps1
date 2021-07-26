[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

$directoryUrl = "https://api.github.com/repos/jasonmcboyd/Environment/git/trees/$Branch`?recursive=1"
Write-Debug "directoryUrl: $directoryUrl"

Invoke-WebRequest $directoryUrl `
| Select-Object -ExpandProperty Content `
| ConvertFrom-Json
