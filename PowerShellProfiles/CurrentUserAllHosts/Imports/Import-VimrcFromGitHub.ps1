function Import-VimrcFromGitHub {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master'
    )

    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/Vim/.vimrc" -OutFile ~/.vimrc
    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/Vim/.viemurc" -OutFile ~/.viemurc
}
