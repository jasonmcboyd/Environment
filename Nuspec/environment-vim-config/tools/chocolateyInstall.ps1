Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = 'environment-vim-config'
  unzipLocation = $env:USERPROFILE
  url           = 'https://github.com/jasonmcboyd/Environment/releases/download/vim-v1.0.3/vim.zip'
  checksum      = 'F084FA06FC67306983D51D3FB9A39641810EB7707FBA5A4BC188FAEEB60C94DFB1C956DDF335AEF47461A18F0EC911AD240E9BD222DD0D63B1B73530DB9E98A4'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
