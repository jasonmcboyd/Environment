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

function Update-ChocoEnvironmentSource {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string] $Username,

    [Parameter(Mandatory)]
    [SecureString] $Pat
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version Latest

  $credential = [System.Management.Automation.PSCredential]::new('PAT', $Pat)
  $plainTextPat = $credential.GetNetworkCredential().Password

  $source =
    & choco sources list -r
    | Select-String '^environment\|'

  if (-not $source) {
    throw "Chocolatey source 'environment' not found."
  }

  $parts     = $source.ToString().Split('|')
  $sourceName = $parts[0]
  $sourceUrl  = $parts[1]

  sudo {
    param($name, $user, $pat, $url)
    & choco sources remove --name $name
    & choco sources add -n $name -u $user -p $pat -s $url
  } -args $sourceName, $username, $plainTextPat, $sourceUrl
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
