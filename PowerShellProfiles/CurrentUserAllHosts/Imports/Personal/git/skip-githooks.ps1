function Skip-GitHooks {
    [CmdletBinding()]
    param (
        [scriptblock]
        $ScriptBlock
    )

    $hooksPath = [string](& git config --local core.hooksPath 2>$null)
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to get core.hooksPath"
        break
    }
    Write-Verbose "Current core.hooksPath: $hooksPath"

    try {
        Write-Verbose "Clearing core.hooksPath"
        & git config --local --unset core.hooksPath

        Write-Verbose "Running script block without git hooks"
        Invoke-Command -ScriptBlock $ScriptBlock
    }
    finally {
        Write-Verbose "Restoring core.hooksPath"
        & git config --local core.hooksPath "'$hooksPath'"
    }
}
