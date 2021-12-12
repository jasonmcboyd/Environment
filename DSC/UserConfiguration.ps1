[CmdletBinding()]
param (
    [Parameter(Position = 0, ParameterSetName = 'Credential')]
    [pscredential]
    $Credential,

    [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'NoCredential')]
    [switch]
    $NoCredential,

    [Parameter(Position = 1, Mandatory = $true)]
    [pscredential]
    $AzureDevOpsPAT
)

if (!$NoCredential -and ($null -eq $Credential)) {
    $Credential = Get-Credential -Message 'Supply credentials for localhost'
}

Configuration Chocolatey {

    Import-DscResource -ModuleName cChoco

    # Install Chocolatey
    cChocoInstaller Chocolatey {
        InstallDir = 'C:\ProgramData\chocolatey'
    }

    # Add environment config Chocolatey source
    cChocoSource Environment {
        Name                 = 'environment'
        Source               = 'https://jasonmcboyd.pkgs.visualstudio.com/be7551c8-9f9d-4c13-b99b-8ee316e13f02/_packaging/environment-settings/nuget/v2'
        Credentials          = $AzureDevOpsPAT
        PsDscRunAsCredential = $Node.Credential
        DependsOn            = '[cChocoInstaller]Chocolatey'
    }

}

Configuration ChocolateyPackages {

    Import-DscResource -ModuleName cChoco

    $chocolateyPackages = @(
        'cascadia-code-nerd-font'
        'environment-powershell-core-profile'
        'environment-vim-config'
        'git'
        'gsudo'
        'notepadplusplus'
        'powershell-core'
        'sysinternals'
        'vscode'
    )

    $windowsBuild = [Environment]::OSVersion.Version.Build

    if ($windowsBuild -ge 18362) {
        $chocolateyPackages += @(
            'environment-windows-terminal-settings'
            'microsoft-windows-terminal'
            'starship'
        )
    }

    if ((Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Hyper-V-All').State -eq 'Enabled') {
        $chocolateyPackages += 'wsl2'
    }

    foreach ($package in $chocolateyPackages) {
        cChocoPackageInstaller $package {
            Name                 = $package
            PsDscRunAsCredential = $Node.Credential
        }
    }
}

Configuration PowerShellPackageManagement {

    Import-DscResource -ModuleName PackageManagement -ModuleVersion '1.4.7'

    PackageManagement SecretManagement {
        Ensure               = 'Present'
        Name                 = 'Microsoft.PowerShell.SecretManagement'
        PsDscRunAsCredential = $Node.Credential
    }

    PackageManagement SecretStore {
        Ensure               = 'Present'
        Name                 = 'Microsoft.PowerShell.SecretStore'
        PsDscRunAsCredential = $Node.Credential
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

Configuration WindowsSnapping {
    $desktopRegistryKey = "HKEY_CURRENT_USER\Control Panel\Desktop"

    # Enable window snapping
    Registry EnableWindowSnapping {
        Key                  = $desktopRegistryKey
        ValueName            = 'WindowArrangementActive'
        Ensure               = 'Present'
        ValueType            = 'String'
        ValueData            = '1'
        PsDscRunAsCredential = $Node.Credential
    }

    $snapRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

    # Disable snap assist (this is what asks what you want to snap next to the window you just snapped).
    Registry DisableSnapAssist {
        Key                  = $snapRegistryKey
        ValueName            = 'SnapAssist'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '0'
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

    # Hide protected operating system files
    Registry ThreeFingerMiddleClick {
        Key                  = $touchpadRegistryKey
        ValueName            = 'ThreeFingerTapEnabled'
        Ensure               = 'Present'
        ValueType            = 'Dword'
        ValueData            = '4'
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

        ChocolateyPackages ChocolateyPackages {
            DependsOn = '[Chocolatey]Chocolatey'
        }

        PowerShellPackageManagement PowerShellPackageManagement {}

        ScreenSaver ScreenSaver {}

        WindowsSnapping WindowsSnapping {}

        WindowsExplorer WindowsExplorer {}

        Touchpad Touchpad {}

        InternetOptions InternetOptions {}

        # I like the idea of clipboard history but, unfortunately, it makes copying sensitive information problematic since you
        # simply copy something else to replace the sensitive information in the clipboard.
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

if ($NoCredential) {
    $configurationData = @{
        AllNodes = @(
            @{
                NodeName                    = 'localhost'
                PsDscAllowPlainTextPassword = $true
            }
        )
    }
}
else {
    $configurationData = @{
        AllNodes = @(
            @{
                NodeName                    = 'localhost'
                PsDscAllowPlainTextPassword = $true
                Credential                  = $Credential
            }
        )
    }
}

User -ConfigurationData $configurationData
