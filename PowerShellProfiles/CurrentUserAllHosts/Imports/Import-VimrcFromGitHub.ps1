function Import-VimrcFromGitHub {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master'
    )

    $userHome = $HOME

    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/Vim/.vimrc" -OutFile "$userHome/.vimrc"
    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/Vim/.viemurc" -OutFile "$userHome/.viemurc"

    if (Test-Path Env:HOME) {
        $path = $env:HOME
        Copy-Item "$userHome/.vimrc" "$path/.vimrc"
        Copy-Item "$userHome/.viemurc" "$path/.viemurc"
    }
    elseif ((Test-Path Env:\HOMEDRIVE) -and (Test-Path Env:\HOMEPATH)) {
        $path = Join-Path $env:HOMEDRIVE $env:HOMEPATH
        Copy-Item "$userHome/.vimrc" "$path/.vimrc"
        Copy-Item "$userHome/.viemurc" "$path/.viemurc"
    }
}
