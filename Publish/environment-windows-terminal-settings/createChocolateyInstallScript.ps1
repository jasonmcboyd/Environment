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

`$destination = (Get-ChildItem "`$(`$env:USERPROFILE)\AppData\Local\Packages" -Directory -Filter '*WindowsTerminal*').FullName

if ((`$null -eq `$destination) -or !(Test-Path `$destination)) {
  throw "Windows Terminal does not appear to be installed."
}

`$destination = Join-Path `$destination 'LocalState'

`$packageArgs = @{
  packageName   = 'environment-windows-terminal-settings'
  unzipLocation = `$destination
  url           = '$ReleaseUrl'
  checksum      = '$ReleaseFileHash'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
"@
