function gd {
  [CmdletBinding()]
  param (
    [int]
    $Count,

    [switch]
    $NameOnly
  )

  $command = 'git diff'

  if ($PSBoundParameters.ContainsKey('Count')) {
    $command += " HEAD~$Count"
  }

  if ($NameOnly) {
    $command += ' --name-only'
  }

  $command += " ':(exclude)*.config'"

  Write-Debug "command: $command"

  Invoke-Expression $command
}
