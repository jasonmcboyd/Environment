[CmdletBinding()]

Configuration System {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        # Set inactivity timeout
        Registry InactivityTimeout {
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'InactivityTimeoutSecs'
            Ensure    = 'Present'
            ValueType = 'Dword'
            ValueData = '300'
        }

        # Enable Hyper V
        WindowsOptionalFeature EnableHyperV {
            Name   = 'Microsoft-Hyper-V-All'
            Ensure = 'Enable'
        }

        # Enable Windows containers
        WindowsOptionalFeature WindowsContainers {
            Name   = 'Containers'
            Ensure = 'Enable'
        }

        # Enable WSL 2
        WindowsOptionalFeature VirtualMachinePlatform {
            Name   = 'VirtualMachinePlatform'
            Ensure = 'Enable'
        }

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
