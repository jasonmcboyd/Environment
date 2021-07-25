function Import-EnvironmentSettings {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master',

        [switch]
        $PowerShell,

        [switch]
        $Vim,

        [switch]
        $WindowsTerminal
    )

    $all = !$PowerShell -and !$Vim -and !$WindowsTerminal
    Write-Debug "all: $all"

    $noImportsDirectory = Get-Item "$PSScriptRoot/../../NoImports" | Select-Object -ExpandProperty FullName
    Write-Debug "noImportsDirectory: $noImportsDirectory"

    if ($all -or $PowerShell) {

        Write-Verbose "Importing PowerShell profile..."

        # Dot source the PowerShell Profile import script.
        . "$noImportsDirectory\Import-ProfileFromGitHub"

        Import-ProfileFromGitHub -Branch $Branch
    }

    if ($all -or $Vim) {

        Write-Verbose "Importing Vimrc..."

        # Dot source the Vimrc import script.
        . "$noImportsDirectory\Import-VimrcFromGitHub"

        Import-VimrcFromGitHub -Branch $Branch
    }

    if ($all -or $WindowsTerminal) {

        Write-Verbose "Importing Windows Terminal settings..."

        # Dot source the Windows Terminal settings import script.
        . "$noImportsDirectory\Import-WindowsTerminalFromGitHub"

        Import-WindowsTerminalFromGitHub -Branch $Branch
    }
}
