function gs { & git status }

function gb { & git branch }

function wgg { watch { Git-Graph -Full -AdditionalGitParameters '--color --decorate --all' } }

Set-Alias -Name gg -Value Git-Graph
