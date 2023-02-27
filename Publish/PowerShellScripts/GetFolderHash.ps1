[CmdletBinding()]
param (
  [string]
  [Parameter(Mandatory = $true)]
  $Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$hashes = @(,(Get-ChildItem -Path $Path -Recurse -File | Get-FileHash | Select-Object -ExpandProperty Hash))

$hex = '0123456789ABCDEF'

$result = [char[]]$hashes[0] | ForEach-Object { $hex.IndexOf($_) }

for ($i = 1; $i -lt $hashes.Count; $i++) {

  $hash = [char[]]$hashes[$i] | ForEach-Object { $hex.IndexOf($_) }

  for ($j = 0; $j -lt $result.Count; $j++) {
    $result[$j] = $result[$j] -bxor $hash[$j]
  }
}

[string]::new(($result | ForEach-Object { $hex[$_] }))
