[CmdletBinding()]
param (
  [string]
  [Parameter(Mandatory = $true)]
  $ReleaseTag,

  [string]
  [Parameter(Mandatory = $true)]
  $GitHubReleasesUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ReleaseTag -match '(?<packageName>[^\d]+)-v(?<versionString>[\d\.]+)$' | Out-Null

$packageName = $Matches.packageName
$versionString = $Matches.versionString
$version = [Version]::Parse($versionString)
$fileName = "$packageName.zip"
$filePath = "$HOME/$fileName"

$releaseUrl = "$GitHubReleasesUrl/download/$ReleaseTag/$fileName"

Write-Debug "releaseUrl: $releaseUrl"

try {
  Invoke-WebRequest -Uri $releaseUrl -OutFile $filePath
  Expand-Archive -Path $filePath -DestinationPath $packageName
  $fileHash = Get-FileHash -Path $filePath -Algorithm SHA256
  $folderHash = & $PSScriptRoot/GetFolderHash.ps1 -Path $packageName
}
finally {
  if (Test-Path $filePath) {
    Remove-Item $filePath
  }

  if (Test-Path $packageName) {
    Remove-Item $packageName -Recurse
  }
}

@{
  PackageName  = $PackageName
  ReleaseUrl   = $releaseUrl
  Version      = $versionString
  MajorVersion = $version.Major
  MinorVersion = $version.Minor
  BuildVersion = $version.Build
  FolderHash   = $folderHash
  FileHash     = $fileHash.Hash
}
