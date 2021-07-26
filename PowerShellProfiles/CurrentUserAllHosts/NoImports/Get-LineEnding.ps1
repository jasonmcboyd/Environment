[CmdletBinding()]
param (
  [string]
  $FilePath
)

$content = Get-Content -Path $FilePath -Raw
$index = $content.IndexOf("`n")

if ($content[$index - 1] -eq "`r") {
  'CRLF'
}
else {
  'LF'
}
