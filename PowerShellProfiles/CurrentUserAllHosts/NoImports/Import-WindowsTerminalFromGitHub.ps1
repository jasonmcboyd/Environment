function Import-WindowsTerminalFromGitHub {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master'
    )

    $userHome = $HOME
    $windowsTerminalDirectory = Get-ChildItem "$userHome\AppData\Local\Packages" -Directory -Filter '*WindowsTerminal*'
    $windowsTerminalSettingsPath = Join-Path $windowsTerminalDirectory 'LocalState\settings.json'

    Write-Debug "windowsTerminalSettingsPath: $windowsTerminalSettingsPath"

    if (!(Test-Path $windowsTerminalSettingsPath)) {
        throw "Windows Terminal settings not found."
    }

    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/WindowsTerminal/settings.json" -OutFile "$windowsTerminalSettingsPath"
}
