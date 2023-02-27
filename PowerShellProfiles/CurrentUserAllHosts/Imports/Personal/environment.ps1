function Update-ChocoEnvironment {
  [CmdletBinding()]
  param (
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version Latest

  $packages =
    & choco list -l -r --id-only `
    | Select-String '^environment.*' `
    | Join-String -Separator ' '

  sudo choco upgrade $packages -y
}
