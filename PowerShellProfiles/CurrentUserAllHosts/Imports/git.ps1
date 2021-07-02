function Git-Graph {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ParameterSetName = 'SpecificBranch, TruncatedLogs')]
        [Parameter(Position = 0, ParameterSetName = 'SpecificBranch, FullLogs')]
        [string[]]
        $Branch = '',

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'AllBranches, TruncatedLogs')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'AllBranches, FullLogs')]
        [switch]
        $All,

        [Parameter(Position = 1, ParameterSetName = 'SpecificBranch, TruncatedLogs')]
        [Parameter(Position = 1, ParameterSetName = 'AllBranches, TruncatedLogs')]
        [int]
        $Number = 10,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'SpecificBranch, FullLogs')]
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'AllBranches, FullLogs')]
        [switch]
        $Full,

        [Parameter(Position = 2)]
        [string]
        $AdditionalGitParameters
    )

    Set-StrictMode -Version 'latest'
    $ErrorActionPreference = 'Stop'

    Write-Debug "ParamterSetName: $($PSCmdlet.ParameterSetName)"

    if ($PSCmdlet.ParameterSetName -like '*AllBranches*') {
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
    if ($PSCmdlet.ParameterSetName -like '*TruncatedLogs*') { $tokens += "-n $Number" }
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

