[CmdletBinding()]
param (
    [string]
    $ReleaseVersion,

    [string]
    $ArchiveFileName,

    [string]
    $ArchiveFileHash
)

@"
Set-StrictMode -Version Latest
`$ErrorActionPreference = 'Stop'

`$packageArgs = @{
  packageName   = 'environment-vim-config'
  unzipLocation = `$env:USERPROFILE
  url           = 'https://github.com/jasonmcboyd/Environment/releases/download/$ReleaseVersion/$ArchiveFileName'
  checksum      = '$ArchiveFileHash'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
"@
