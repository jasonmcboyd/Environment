function Use-Location {
  [CmdletBinding()]
  param (
    [string]
    $Path,

    [ScriptBlock]
    $ScriptBlock
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version Latest

  push-location $Path
  try {
    Invoke-Command -ScriptBlock $ScriptBlock
  }
  finally {
    Pop-Location
  }
}

Set-Alias -Name ul -Value Use-Location
