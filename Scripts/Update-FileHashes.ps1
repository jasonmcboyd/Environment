[CmdletBinding()]
param ()

$repositoryDirectory = Get-Item "$PSScriptRoot/.." | Select-Object -ExpandProperty FullName
Write-Debug "repositoryDirectory: $repositoryDirectory"

$powershellProfilesDirectory = Get-Item "$PSScriptRoot/../PowerShellProfiles" | Select-Object -ExpandProperty FullName
$vimDirectory = Get-Item "$PSScriptRoot/../Vim" | Select-Object -ExpandProperty FullName
$windowsTerminalDirectory = Get-Item "$PSScriptRoot/../WindowsTerminal" | Select-Object -ExpandProperty FullName

if (!(Test-Path $powershellProfilesDirectory)) {
  throw "Could not find PowerShell profiles path."
}

if (!(Test-Path $vimDirectory)) {
  throw "Could not find Vim path."
}

if (!(Test-Path $windowsTerminalDirectory)) {
  throw "Could not find Windows Terminal path."
}

$filehashesPath = "$PSScriptRoot/../filehashes.json"

Remove-Item $filehashesPath -ErrorAction SilentlyContinue

$hashes = @()
$files = @()

$files += Get-ChildItem $powershellProfilesDirectory -Recurse -File -Filter '*.ps1'
$files += Get-ChildItem $vimDirectory
$files += Get-ChildItem $windowsTerminalDirectory

foreach ($file in $files) {
  $relativePath = ($file | Select-Object -ExpandProperty FullName).Replace($repositoryDirectory, '').Replace('\', '/')
  $lineEnding = & "$PSScriptRoot/Get-LineEnding.ps1" -Path $file
  if ($lineEnding -eq 'CRLF') {
    $crlfHash = (Get-FileHash -Path $file).Hash
    $lfHash = (Get-FileHash -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes((Get-Content -Path $file -Raw).Replace("`r`n", "`r"))))).Hash
  }
  else {
    $crlfHash = (Get-FileHash -InputStream ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes((Get-Content -Path $file -Raw).Replace("`r", "`r`n"))))).Hash
    $lfHash = (Get-FileHash -Path $file).Hash
  }
  $obj = [PSCustomObject]@{
    RelativePath = $relativePath
    FileHash     = [PSCustomObject]@{
      CRLF = $crlfHash
      LF = $lfHash
    }
  }
  $hashes += $obj
}

$hashes | ConvertTo-Json -Depth 10 | Set-Content -Path $filehashesPath
