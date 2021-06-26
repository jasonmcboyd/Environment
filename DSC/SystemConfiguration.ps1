[CmdletBinding()]

Configuration System {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        #region Windows Features

            Registry DefaultWebPage {
                Key = $internetExplorerRegistryKey
                ValueName = 'Default_Page_URL'
                Ensure = 'Present'
                ValueType = 'String'
                ValueData = 'https://www.duckduckgo.com'
                PsDscRunAsCredential = $Node.Credentials
            }

        #endregion Windows Features

    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
        }
    )
}

System -ConfigurationData $configurationData
