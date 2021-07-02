function Git-Graph {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ParameterSetName = 'TruncatedBranch')]
        [Parameter(Position = 0, ParameterSetName = 'FullBranch')]
        [string[]]
        $Branch = '',

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'TruncatedAllBranches')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'FullAllBranches')]
        [switch]
        $All,

        [Parameter(Position = 1, ParameterSetName = 'TruncatedBranch')]
        [Parameter(Position = 1, ParameterSetName = 'TruncatedAllBranches')]
        [int]
        $Number = 10,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'FullBranch')]
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'FullAllBranches')]
        [switch]
        $Full,

        [switch]
        $Color
    )

    Write-Debug "ParamterSetName: $($PSCmdlet.ParameterSetName)"

    if ($PSCmdlet.ParameterSetName -eq 'AllBranches') {
        $branches = '--all' 
    }
    else {
        if (![string]::IsNullOrWhiteSpace('Branch')) {
            $branches = $Branch
        }
        else {
            $branches = & git branch --show-current
        }
    }

    Write-Debug "branches: $branches"

    $command = 'git log --graph --oneline'
    if ($Color) { $command += ' --color' }
    if ($PSBoundParameters.ContainsKey('Number')) { $command += " -n $Number" }
    $command += $brances

    Write-Debug "command: $command"

    Invoke-Expression $command
}

function gs { & git status }
function gb { & git branch }

function wgg { watch { Git-Graph -Full -Color } }

Set-Alias -Name gg -Value Git-Graph
