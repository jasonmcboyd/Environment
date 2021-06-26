function Git-Graph {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $false, ParameterSetName = 'SpecificBranches')]
        [string[]]
        $Branch = '',

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'AllBranches')]
        [switch]
        $All,

        [int]
        $Number
    )

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

    & git log --graph --oneline $branches $(if ($PSBoundParameters.ContainsKey('Number')) { "-n $Number" })
}

function gs { & git status }
function gb { & git branch }

Set-Alias -Name gg -Value Git-Graph
