[CmdletBinding()]
param (
  [string]
  $FilePath,

  [string]
  $Key,

  [ValidateSet('LF', 'CRLF')]
  [string]
  $LineEnding,

  $RemoteFileHashes
)

if (Test-Path $FilePath) {
  $localFileHash = Get-FileHash -Path $FilePath | Select-Object -ExpandProperty Hash
}
else {
  $localFileHash = ''
}

$remoteFileHash =
  $RemoteFileHashes `
  | Where-Object { $_.RelativePath -eq $Key } `
  | Select-Object -ExpandProperty FileHash `
  | Select-Object -ExpandProperty $LineEnding

$hashesMatch = $localFileHash -eq $remoteFileHash
Write-Debug @"
Hash Comparison:
    $FilePath : $localFileHash
    $Key : $remoteFileHash
    Match : $hashesMatch
"@

$hashesMatch
