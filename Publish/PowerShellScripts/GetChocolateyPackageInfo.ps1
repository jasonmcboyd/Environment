[CmdletBinding()]
param (
  [string]
  [Parameter(Mandatory = $true)]
  $PackageName,

  [string]
  [Parameter(Mandatory = $true)]
  $NuGetUrl,

  [string]
  [Parameter(Mandatory = $true)]
  $AzureDevOpsUserName,

  [string]
  [Parameter(Mandatory = $true)]
  $AzureDevOpsPersonalAccessToken
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$credentials = [pscredential]::new($AzureDevOpsUserName, (ConvertTo-SecureString -String $AzureDevOpsPersonalAccessToken -AsPlainText -Force))

$json = Invoke-RestMethod -Uri $NuGetUrl -Authentication Basic -Credential $credentials

$registrationsUrl = $json.resources | Where-Object { $_.'@type' -eq 'RegistrationsBaseUrl/3.6.0' } | Select-Object -First 1 -ExpandProperty '@id'

$json = Invoke-RestMethod -Uri "$registrationsUrl/$PackageName" -Authentication Basic -Credential $credentials

$versionString = $json.items.upper
$version = [Version]::Parse($versionString)

$packageUrl = $json.items.items[0].packageContent
$fileName = 'package.nupkg'

try {
  Invoke-WebRequest -Uri $packageUrl -Authentication Basic -Credential $credentials -OutFile $fileName
  $fileHash = Get-FileHash -Path  $fileName -Algorithm SHA256
}
finally {
  if (Test-Path $fileName) {
    Remove-Item $fileName
  }
}

@{
  PackageName        = $PackageName
  VersionNumber      = $versionString
  MajorVersionNumber = $version.Major
  MinorVersionNumber = $version.Minor
  BuildVersionNumber = $version.Build
  FileHash           = $fileHash.Hash
}
