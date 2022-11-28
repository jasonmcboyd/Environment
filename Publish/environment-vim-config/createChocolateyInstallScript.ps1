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

`$packageArgs = @{
  packageName   = 'environment-vim-config'
  unzipLocation = `$env:USERPROFILE
  url           = '$ReleaseUrl'
  checksum      = '$ReleaseFileHash'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
"@
