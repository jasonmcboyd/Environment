[CmdletBinding()]
param (
    [string]
    $ReleaseUrl,

    [string]
    $ReleaseFileHash
)

@"
Set-StrictMode -Version Latest
`$ErrorActionPreference = 'Stop'

`$destination = "`$env:USERPROFILE/Documents/PowerShell"

if (Test-Path "`$destination/Imports/Personal") {
  Remove-Item "`$destination/Imports/Personal/*" -Recurse -Force
}

`$packageArgs = @{
  packageName   = 'environment-powershell-core-profile'
  unzipLocation = `$destination
  url           = '$ReleaseUrl'
  checksum      = '$ReleaseFileHash'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
"@
