[CmdletBinding()]
param (
    [string]
    $ReleaseUrl,

    [string]
    $ReleaseFileHash
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

@"
Set-StrictMode -Version Latest
`$ErrorActionPreference = 'Stop'

Install-ChocolateyEnvironmentVariable ``
  -VariableName 'STARSHIP_CONFIG' ``
  -VariableValue "`$HOME\.starship\config.toml" ``
  -VariableType 'User'

Install-ChocolateyEnvironmentVariable ``
  -VariableName 'STARSHIP_CACHE' ``
  -VariableValue "`$HOME\.starship\cache" ``
  -VariableType 'User'

`$destination = Split-Path `$ENV:STARSHIP_CONFIG

if (!(Test-Path `$destination)) {
  mkdir `$destination
}

`$packageArgs = @{
  packageName   = 'environment-starship-config'
  unzipLocation = `$destination
  url           = '$ReleaseUrl'
  checksum      = '$ReleaseFileHash'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
"@
