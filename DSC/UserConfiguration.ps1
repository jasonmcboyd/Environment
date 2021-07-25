[CmdletBinding()]
param (
    [Parameter(ParameterSetName = 'Credentials')]
    [pscredential]
    $Credentials,

    [Parameter(Mandatory = $true, ParameterSetName = 'NoCredentials')]
    [switch]
    $NoCredentials
)

if (!$NoCredentials -and ($null -eq $Credentials)) {
    $Credentials = Get-Credential -Message 'Supply credentials for localhost'
}

Configuration User {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        #region Windows Snap Settings

        $desktopRegistryKey = "HKEY_CURRENT_USER\Control Panel\Desktop"

        # Enable window snapping
        Registry EnableWindowSnapping {
            Key                  = $desktopRegistryKey
            ValueName            = 'WindowArrangementActive'
            Ensure               = 'Present'
            ValueType            = 'String'
            ValueData            = '1'
            PsDscRunAsCredential = $Node.Credentials
        }

        $snapRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

        # Disable snap assist (this is what asks what you want to snap next to the window you just snapped).
        Registry DisableSnapAssist {
            Key                  = $snapRegistryKey
            ValueName            = 'SnapAssist'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '0'
            PsDscRunAsCredential = $Node.Credentials
        }

        #region Windows Snap Settings

        #region Windows Explorer Settings

        $explorerAdvancedSettingsRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        $explorerCabinetStateRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'

        # Show file extensions for known file types.
        Registry ShowFileExtensions {
            Key                  = $explorerAdvancedSettingsRegistryKey
            ValueName            = 'HideFileExt'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '0'
            PsDscRunAsCredential = $Node.Credentials
        }

        # Display the full path in the address bar.
        Registry DisplayFullPath {
            Key                  = $explorerCabinetStateRegistryKey
            ValueName            = 'FullPath'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '1'
            PsDscRunAsCredential = $Node.Credentials
        }

        # Show hidden file, folders, and drives.
        Registry ShowHiddenFiles {
            Key                  = $explorerAdvancedSettingsRegistryKey
            ValueName            = 'Hidden'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '1'
            PsDscRunAsCredential = $Node.Credentials
        }

        # Hide protected operating system files
        Registry HideSystemFiles {
            Key                  = $explorerAdvancedSettingsRegistryKey
            ValueName            = 'ShowSuperHidden'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '0'
            PsDscRunAsCredential = $Node.Credentials
        }

        #endregion Windows Explorer Settings

        #region Touchpad Settings

        $touchpadRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'

        # Hide protected operating system files
        Registry ThreeFingerMiddleClick {
            Key                  = $touchpadRegistryKey
            ValueName            = 'ThreeFingerTapEnabled'
            Ensure               = 'Present'
            ValueType            = 'Dword'
            ValueData            = '4'
            PsDscRunAsCredential = $Node.Credentials
        }

        #endregion Touchpad Settings

        #region Internet Options

        $internetExplorerRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\InternetExplorer\Main'

        Registry DefaultWebPage {
            Key                  = $internetExplorerRegistryKey
            ValueName            = 'Default_Page_URL'
            Ensure               = 'Present'
            ValueType            = 'String'
            ValueData            = 'https://www.duckduckgo.com'
            PsDscRunAsCredential = $Node.Credentials
        }

        #endregion Internet Options

    }
}

if ($NoCredentials) {
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
                Credentials                 = $Credentials
            }
        )
    }
}

User -ConfigurationData $configurationData
