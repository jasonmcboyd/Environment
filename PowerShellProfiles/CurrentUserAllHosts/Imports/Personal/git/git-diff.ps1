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
    $NameOnly,

    [switch]
    $ExcludeWhiteSpace,

    [string[]]
    $Exclude = @('*.config', '*.Designer.cs')
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

  if ($ExcludeWhiteSpace) {
    $command += ' --ignore-all-space'
  }

  foreach ($ex in $Exclude) {
    $command += " ':(exclude)$ex'"
  }

  Write-Debug "command: $command"

  Invoke-Expression $command
}
