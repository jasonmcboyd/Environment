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

$ReleaseTag -match '(?<releaseName>[^\d]+)-v(?<versionString>[\d\.]+)$' | Out-Null

$releaseName = $Matches.releaseName
$versionString = $Matches.versionString
$version = [Version]::Parse($versionString)
$fileName = "$releaseName.zip"
$filePath = "$HOME/$fileName"

$downloadUrl = "$GitHubReleasesUrl/download/$ReleaseTag/$fileName"

Write-Debug "downloadUrl: $downloadUrl"

try {
  Invoke-WebRequest -Uri $downloadUrl -OutFile $filePath
  Expand-Archive -Path $filePath -DestinationPath $releaseName
  $fileHash = Get-FileHash -Path $filePath -Algorithm SHA256
  $folderHash = & $PSScriptRoot/GetFolderHash.ps1 -Path $releaseName
}
finally {
  if (Test-Path $filePath) {
    Remove-Item $filePath
  }

  if (Test-Path $releaseName) {
    Remove-Item $releaseName -Recurse
  }
}

@{
  ReleaseName        = $releaseName
  ReleaseTag         = $ReleaseTag
  DownloadUrl        = $downloadUrl
  VersionNumber      = $versionString
  MajorVersionNumber = $version.Major
  MinorVersionNumber = $version.Minor
  BuildVersionNumber = $version.Build
  FolderHash         = $folderHash
  FileHash           = $fileHash.Hash
}
