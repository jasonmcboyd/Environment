[CmdletBinding()]
param (
  [string]
  $Branch = 'master',

  [string]
  $FilePath,

  [string]
  $GitHubUrl,

  $RemoteFileHashes
)

$localFileHash = Get-FileHash -Path $FilePath | Select-Object -ExpandProperty Hash

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch

$fileHashLookupKey = $GitHubUrl.Replace($rootUrl, '').Replace('/', '\')
Write-Debug "fileHashLookupKey: $fileHashLookupKey"

$remoteFileHash =
  $RemoteFileHashes `
  | Where-Object { $_.RelativePath -eq $fileHashLookupKey } `
  | Select-Object -ExpandProperty FileHash

$hashesMatch = $localFileHash -eq $remoteFileHash
Write-Debug @"
Hash Comparison:
    $FilePath : $localFileHash
    $GitHuburl : $remoteFileHash
    Match : $hashesMatch
"@
$hashesMatch
