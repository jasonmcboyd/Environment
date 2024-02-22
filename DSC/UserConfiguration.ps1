[CmdletBinding()]
param (
    [Parameter(Position = 0, Mandatory = $true)]
    [pscredential]
    $Credential,

    [Parameter(Position = 1, Mandatory = $true)]
    [pscredential]
    $AzureDevOpsPATCredential
)

Configuration Chocolatey {

    Import-DscResource -ModuleName cChoco

    # Install Chocolatey
    cChocoInstaller Chocolatey {
        InstallDir = 'C:\ProgramData\chocolatey'
    }
}

Configuration PowerShellSecretManagement {

    Import-DscResource -ModuleName PackageManagement

    PackageManagement SecretManagement {
        Ensure               = 'Present'
        Name                 = 'Microsoft.PowerShell.SecretManagement'
        PsDscRunAsCredential = $Node.Credential
    }

    PackageManagement SecretStore {
        Ensure               = 'Present'
        Name                 = 'Microsoft.PowerShell.SecretStore'
        PsDscRunAsCredential = $Node.Credential
        DependsOn            = '[PackageManagement]SecretManagement'
    }

    Script SecretVault {
        TestScript = {
            $secretVault = Get-SecretVault -Name 'LocalStore' -ErrorAction SilentlyContinue
            return $null -ne $secretVault
        }
        GetScript = { @{ Result = Get-SecretVault -Name 'LocalStore' -ErrorAction SilentlyContinue } }
        SetScript = {
            $secretVault = Get-SecretVault -Name 'LocalStore' -ErrorAction SilentlyContinue
            if ($null -eq $secretVault) {
                Register-SecretVault `
                    -Name 'LocalStore' `
                    -ModuleName 'Microsoft.PowerShell.SecretStore' `
                    -DefaultVault

                Set-SecretStoreConfiguration `
                    -Name 'LocalStore' `
                    -Password $($using:Node.Credential.Password)
            }
        }
        PsDscRunAsCredential = $Node.Credential
        DependsOn            = '[PackageManagement]SecretStore'
    }

    Script EnvironmentPersonalAccessToken {
        TestScript = {
            Unlock-SecretStore -Password $($using:Node.Credential.Password)
            $secret = Get-SecretInfo -Name 'environment-pat' -ErrorAction SilentlyContinue
            return $null -ne $secret
        }
        GetScript = {
            Unlock-SecretStore -Password $($using:Node.Credential.Password)
            @{ Result = Get-SecretInfo -Name 'environment-pat' -ErrorAction SilentlyContinue }
        }
        SetScript = {
            Unlock-SecretStore -Password $($using:Node.Credential.Password)
            $secret = Get-SecretInfo -Name 'environment-pat' -ErrorAction SilentlyContinue
            if ($null -eq $secret) {
                Set-Secret -Vault 'LocalStore' -Name 'environment-pat' -Secret $($using:Node.AzureDevOpsPATCredential.Password)
            }
        }
        PsDscRunAsCredential = $Node.Credential
        DependsOn            = '[Script]SecretVault'
    }
}

Configuration ChocolateyPackages {

    Import-DscResource -ModuleName cChoco

    # Add environment config Chocolatey source
    cChocoSource Environment {
        Name                 = 'environment'
        Source               = 'https://jasonmcboyd.pkgs.visualstudio.com/be7551c8-9f9d-4c13-b99b-8ee316e13f02/_packaging/environment-settings/nuget/v2'
        Credentials          = $Node.AzureDevOpsPATCredential
        PsDscRunAsCredential = $Node.Credential
    }

    $chocolateyPackages = @(
        'cascadia-code-nerd-font'
        'environment-powershell-core-profile'
        'environment-starship-config'
        'environment-vim-config'
        'git'
        'gsudo'
        'powershell-core'
    )

    foreach ($package in $chocolateyPackages) {
        cChocoPackageInstaller $package {
            Name                 = $package
            PsDscRunAsCredential = $Node.Credential
            DependsOn            = '[cChocoSource]Environment'
        }
    }
}

Configuration ScreenSaver {

    $controlPanelDesktopRegistryKey = 'HKEY_CURRENT_USER\Control Panel\Desktop'

    # Turn on the screen saver.
    Registry EnableScreenSaver {
        Key                  = $controlPanelDesktopRegistryKey
        ValueName            = 'ScreenSaveActive'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = '1'
        PsDscRunAsCredential = $Node.Credential
    }

    # Require logging in when returning from the screen saver.
    Registry EnableScreenSaverLogin {
        Key                  = $controlPanelDesktopRegistryKey
        ValueName            = 'ScreenSaverIsSecure'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = '1'
        PsDscRunAsCredential = $Node.Credential
    }

    # Screen saver timeout.
    Registry SetScreensaverTimer {
        Key                  = $controlPanelDesktopRegistryKey
        ValueName            = 'ScreenSaveTimeOut'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = '300'
        PsDscRunAsCredential = $Node.Credential
    }
}

Configuration WindowsExplorer {
    $explorerAdvancedSettingsRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $explorerCabinetStateRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'

    # Show file extensions for known file types.
    Registry ShowFileExtensions {
        Key                  = $explorerAdvancedSettingsRegistryKey
        ValueName            = 'HideFileExt'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '0'
        PsDscRunAsCredential = $Node.Credential
    }

    # Display the full path in the address bar.
    Registry DisplayFullPath {
        Key                  = $explorerCabinetStateRegistryKey
        ValueName            = 'FullPath'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '1'
        PsDscRunAsCredential = $Node.Credential
    }

    # Show hidden file, folders, and drives.
    Registry ShowHiddenFiles {
        Key                  = $explorerAdvancedSettingsRegistryKey
        ValueName            = 'Hidden'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '1'
        PsDscRunAsCredential = $Node.Credential
    }

    # Hide protected operating system files
    Registry HideSystemFiles {
        Key                  = $explorerAdvancedSettingsRegistryKey
        ValueName            = 'ShowSuperHidden'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '0'
        PsDscRunAsCredential = $Node.Credential
    }
}

Configuration Touchpad {
    $touchpadRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'

    # Three finger tap for middle click.
    Registry ThreeFingerMiddleClick {
        Key                  = $touchpadRegistryKey
        ValueName            = 'ThreeFingerTapEnabled'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '4'
        PsDscRunAsCredential = $Node.Credential
    }

    # Double tap for multi-select.
    Registry DoubleTapAndDrag {
        Key                  = $touchpadRegistryKey
        ValueName            = 'TapAndDrag'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = 0xffffffff
        PsDscRunAsCredential = $Node.Credential
    }
}

Configuration Desktop {
    $themeRegistryKey = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes'
    $darkModeRegistryKey = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # Dark mode for apps.
    Registry AppsDarkMode {
        Key                  = $darkModeRegistryKey
        ValueName            = 'AppsUseLightTheme'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '0'
        PsDscRunAsCredential = $Node.Credential
    }

    # Dark mode for system.
    Registry SystemDarkMode {
        Key                  = $darkModeRegistryKey
        ValueName            = 'SystemUsesLightTheme'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '0'
        PsDscRunAsCredential = $Node.Credential
    }

    # Dark theme.
    Registry DarkTheme {
        Key                  = $themeRegistryKey
        ValueName            = 'CurrentTheme'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = 'C:\Windows\resources\Themes\dark.theme'
        PsDscRunAsCredential = $Node.Credential
    }
}

Configuration InternetOptions {
    $internetExplorerRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\InternetExplorer\Main'

    Registry DefaultWebPage {
        Key                  = $internetExplorerRegistryKey
        ValueName            = 'Default_Page_URL'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = 'https://www.duckduckgo.com'
        PsDscRunAsCredential = $Node.Credential
    }
}

Configuration User {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        Chocolatey Chocolatey {}

        PowerShellSecretManagement PowerShellSecretManagement {}

        ChocolateyPackages ChocolateyPackages {
            DependsOn = @(
                '[PowerShellSecretManagement]PowerShellSecretManagement'
                '[Chocolatey]Chocolatey')
        }

        ScreenSaver ScreenSaver {}

        WindowsExplorer WindowsExplorer {}

        Touchpad Touchpad {}

        Desktop Desktop {}

        InternetOptions InternetOptions {}

        # I like the idea of clipboard history but, unfortunately, it makes copying sensitive information problematic.
        # With the regular clipboard, simply copying something else replaces the sensitive information in the clipboard.
        # With clipboard history, the sensitive information is still available in the history.
        Registry ClipboardHistory {
            Key                  = 'HKEY_CURRENT_USER\Software\Microsoft\Clipboard'
            ValueName            = 'EnableClipboardHistory'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '0'
            PsDscRunAsCredential = $Node.Credential
        }
    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName                    = 'localhost'
            PsDscAllowPlainTextPassword = $true
            Credential                  = $Credential
            AzureDevOpsPATCredential    = $AzureDevOpsPATCredential
        }
    )
}

User -ConfigurationData $configurationData
