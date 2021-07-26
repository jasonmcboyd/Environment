[CmdletBinding()]
param (
  [string]
  $Branch = 'master'
)

$targetDirectories = [System.Collections.Generic.HashSet[string]]::new()
$targetDirectories.Add($HOME) | Out-Null

if (Test-Path Env:\HOME) {
  $path = $env:HOME

  Write-Debug "Env:\HOME exists, path is $path."

  $targetDirectories.Add($path) | Out-Null
}
elseif ((Test-Path Env:\HOMEDRIVE) -and (Test-Path Env:\HOMEPATH)) {
  $path = Join-Path $env:HOMEDRIVE $env:HOMEPATH

  Write-Debug "Env:\HOMEDRIVE and Env:\HOMEPATH exists, path is $path."

  $targetDirectories.Add($path) | Out-Null
}

Write-Debug "targetDirectories:`r`n$targetDirectories"
Write-Debug $targetDirectories.Length

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$files = @('.vimrc', '.viemurc')

foreach ($file in $files) {
  foreach ($targetDirectory in $targetDirectories) {
    $url = "$rootUrl/Vim/$file"
    Write-Debug "url: $url"

    $destination = "$targetDirectory\$file"
    Write-Debug "destination: $destination"

    [PSCustomObject]@{
      Url         = $url
      Destination = $destination
      LineEnding  = "LF"
    }
  }
}
