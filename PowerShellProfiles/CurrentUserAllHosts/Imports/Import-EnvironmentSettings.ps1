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

    $remoteFileHashes = & "$noImportsDirectory/Get-RemoteFileHashes.ps1" -Branch $Branch

    if ($all -or $PowerShell) {

        Write-Verbose "Importing PowerShell profile..."

        & "$noImportsDirectory/Import-ProfileFromGitHub.ps1" -Branch $Branch -RemoteFileHashes $remoteFileHashes
    }

    if ($all -or $Vim) {

        Write-Verbose "Importing Vimrc..."

        & "$noImportsDirectory/Import-VimrcFromGitHub.ps1" -Branch $Branch -RemoteFileHashes $remoteFileHashes
    }

    if ($all -or $WindowsTerminal) {

        Write-Verbose "Importing Windows Terminal settings..."

        & "$noImportsDirectory/Import-WindowsTerminalFromGitHub.ps1" -Branch $Branch -RemoteFileHashes $remoteFileHashes
    }
}
