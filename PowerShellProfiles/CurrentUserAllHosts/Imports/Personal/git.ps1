function Git-Graph {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ParameterSetName = 'Branch, Number')]
        [Parameter(Position = 0, ParameterSetName = 'Branch, Full')]
        [string[]]
        $Branch = '',

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'All, Number')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'All, Full')]
        [switch]
        $All,

        [Parameter(Position = 1, ParameterSetName = 'Branch, Number')]
        [Parameter(Position = 1, ParameterSetName = 'All, Number')]
        [int]
        $Number = 10,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Branch, Full')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'All, Full')]
        [switch]
        $Full,

        [Parameter(Position = 2)]
        [string]
        $AdditionalGitParameters
    )

    Set-StrictMode -Version 'latest'
    $ErrorActionPreference = 'Stop'

    Write-Debug "ParamterSetName: $($PSCmdlet.ParameterSetName)"

    if ($PSCmdlet.ParameterSetName -like '*All*') {
        $branches = '--all' 
    }
    else {
        $branches = $Branch
    }

    Write-Debug "branches: $branches"

    $tokens = @(
        'git log --graph --oneline'
    )
    if (![string]::IsNullOrEmpty($AdditionalGitParameters)) { $tokens += $AdditionalGitParameters }
    if ($PSCmdlet.ParameterSetName -like '*Number*') { $tokens += "-n $Number" }
    if (![string]::IsNullOrEmpty($branches)) { $tokens += $branches }

    $command = [string]::Join(' ', $tokens)

    Write-Debug "AdditionalGitParameters: $AdditionalGitParameters"

    Write-Debug "command: $command"

    Invoke-Expression $command
}

function gs { & git status }
function gb { & git branch }

function wgg { watch { Git-Graph -Full -AdditionalGitParameters '--color --decorate --all' } }

Set-Alias -Name gg -Value Git-Graph

