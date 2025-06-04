function gis { & git status }

function gib { & git branch }

function gim {
  [CmdletBinding()]
  param(
  )

  if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
    Write-Error "Not in a git repository."
    return
  }

  $branchNames = @('master', 'main')

  foreach ($branchName in $branchNames) {
    $pattern = "\s*$branchName`$"

    if ((git branch | sls -Pattern $branchName | measure).Count -eq 1) {
      Write-Verbose "Found '$branchName' branch."

      Write-Verbose "Fetching..."
      & git fetch

      Write-Verbose "Checking out '$branchName' branch."
      & git checkout $branchName

      Write-Verbose "Pulling latest on '$branchName' branch."
      & git pull
      return
    }
  }

  Write-Error @"
Could not find any of the following branches:

$($branchNames -join [Environment]::NewLine)
"@
}

function wgig { watch { Git-Graph -Full -AdditionalGitParameters '--color --decorate --all' } }

Set-Alias -Name gig -Value Git-Graph
Set-Alias -Name gid -Value Git-Diff
Set-Alias -Name no-verify -Value Skip-GitHooks

Import-Module posh-git
