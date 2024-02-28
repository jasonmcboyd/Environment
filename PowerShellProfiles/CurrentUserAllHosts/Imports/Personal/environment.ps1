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

function Update-ProcessEnvironmentVariable {
  [CmdletBinding()]
  param (
    # TODO: Add '[string[]] Variable' parameter some day.
  )

  $environmentVariableTargets = @('Machine', 'User')

  # TODO: I want to update all environment variables eventually, but Path is the only one I care about right now.
  $paths =
    $environmentVariableTargets `
    | ForEach-Object {
      [System.Environment]::GetEnvironmentVariable('Path', $_).Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
    } `
    | Select-Object -Unique `
    | Sort-Object

  $env:Path = $paths -join ';'
}
