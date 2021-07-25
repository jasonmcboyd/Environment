[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl" -Branch $Branch

$fileHashesUrl = "$rootUrl/filehashes.json"
Invoke-RestMethod $fileHashesUrl
