function Git-Diff {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, ParameterSetName = 'Count')]
    [int]
    $Count,

    [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'Branch')]
    [string]
    $Branch,

    [switch]
    $NameOnly
  )

  $command = 'git diff'

  if ($PSBoundParameters.ContainsKey('Count')) {
    $command += " HEAD~$Count"
  }

  if ($PSBoundParameters.ContainsKey('Branch')) {
    $command += " $Branch"
  }

  if ($NameOnly) {
    $command += ' --name-only'
  }

  $command += " ':(exclude)*.config'"

  Write-Debug "command: $command"

  Invoke-Expression $command
}
