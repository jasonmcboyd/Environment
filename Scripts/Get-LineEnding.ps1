[CmdletBinding()]
param (
  [string]
  $Path
)

$content = Get-Content -Path $Path -Raw
$index = $content.IndexOf("`n")

if ($content[$index - 1] -eq "`r") {
  'CRLF'
}
else {
  'LF'
}
