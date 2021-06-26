[CmdletBinding()]

Configuration User {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        #region Windows Explorer Settings
    
            # Store the registry keys in veriables
            $explorerAdvancedSettingsRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            $explorerCabinetStateRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
            
            # Show file extensions for known file types.
            Registry ShowFileExtensions {
                Key = $explorerAdvancedSettingsRegistryKey
                ValueName = 'HideFileExt'
                Ensure = 'Present'
                ValueType = 'Dword'
                ValueData = '0'
                PsDscRunAsCredential = $Node.Credentials
            }

            # Display the full path in the address bar.
            Registry DisplayFullPath {
                Key = $explorerCabinetStateRegistryKey
                ValueName = 'FullPath'
                Ensure = 'Present'
                ValueType = 'Dword'
                ValueData = '1'
                PsDscRunAsCredential = $Node.Credentials
            }

            # Show hidden file, folders, and drives.
            Registry ShowHiddenFiles {
                Key = $explorerAdvancedSettingsRegistryKey
                ValueName = 'Hidden'
                Ensure = 'Present'
                ValueType = 'Dword'
                ValueData = '1'
                PsDscRunAsCredential = $Node.Credentials
            }

            # Hide protected operating system files
            Registry HideSystemFiles {
                Key = $explorerAdvancedSettingsRegistryKey
                ValueName = 'ShowSuperHidden'
                Ensure = 'Present'
                ValueType = 'Dword'
                ValueData = '0'
                PsDscRunAsCredential = $Node.Credentials
            }
    
        #endregion Windows Explorer Settings

        #region Touchpad Settings

            $touchpadRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\PrecisionTouchPad'

            # Hide protected operating system files
            Registry ThreeFingerMiddleClick {
                Key = $touchpadRegistryKey
                ValueName = 'ThreeFingerTapEnabled'
                Ensure = 'Present'
                ValueType = 'Dword'
                ValueData = '4'
                PsDscRunAsCredential = $Node.Credentials
            }

        #endregion Touchpad Settings

        #region Internet Options

            $internetExplorerRegistryKey = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\InternetExplorer\Main'

            Registry DefaultWebPage {
                Key = $internetExplorerRegistryKey
                ValueName = 'Default_Page_URL'
                Ensure = 'Present'
                ValueType = 'String'
                ValueData = 'https://www.duckduckgo.com'
                PsDscRunAsCredential = $Node.Credentials
            }

        #endregion Internet Options
    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PsDscAllowPlainTextPassword = $true
            Credentials = Get-Credential -Message 'Supply credentials for localhost'
        }
    )
}

User -ConfigurationData $configurationData
