[CmdletBinding()]
param (
  [string]
  $FilePath,

  [string]
  $Key,

  $RemoteFileHashes
)

if (Test-Path) {
  $localFileHash = Get-FileHash -Path $FilePath | Select-Object -ExpandProperty Hash
}
else {
  $localFileHash = ''
}

$remoteFileHash =
  $RemoteFileHashes `
  | Where-Object { $_.RelativePath -eq $Key } `
  | Select-Object -ExpandProperty FileHash

$hashesMatch = $localFileHash -eq $remoteFileHash
Write-Debug @"
Hash Comparison:
    $FilePath : $localFileHash
    $Key : $remoteFileHash
    Match : $hashesMatch
"@
$hashesMatch
