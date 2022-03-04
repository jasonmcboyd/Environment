function gis { & git status }

function gib { & git branch }

function gim { & git fetch; git checkout master; git pull }

function wgig { watch { Git-Graph -Full -AdditionalGitParameters '--color --decorate --all' } }

Set-Alias -Name gig -Value Git-Graph
Set-Alias -Name gid -Value Git-Diff
