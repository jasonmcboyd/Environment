[CmdletBinding()]
param (
  [Hashtable]
  [Parameter(Mandatory = $true)]
  $HashTable
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$parsedKeys = @{}

foreach ($key in $HashTable.Keys) {
  $strings = @()
  foreach ($char in $key.GetEnumerator()) {
    if ([Char]::IsUpper($char)) {
      $strings += $char.ToString()
    }
    else {
      $strings[$strings.Count - 1] += $char
    }
  }

  $parsedKeys.Add($key, $strings)
}

foreach ($key in $HashTable.Keys) {
  Write-Object "$([string]::Join("-", ($parsedKeys[$key] | ForEach-Object { $_.ToLower() })))=$($HashTable[$key])" >> $env:GITHUB_OUTPUT
}

foreach ($key in $HashTable.Keys) {
  Write-Host "$([string]::Join(' ', $parsedKeys[$key])): $($HashTable[$key])"
}
