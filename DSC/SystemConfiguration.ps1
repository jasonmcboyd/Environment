[CmdletBinding()]

Configuration DscResources {
    Import-DscResource -ModuleName PackageManagement

    # Install Chocolatey DSC resources
    PackageManagement cChocoPackage {
        Ensure = 'Present'
        Name   = 'cChoco'
        PsDscRunAsCredential = $Node.Credentials
    }
}

Configuration System {

    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName {

        DscResources DscResources {}

        # Enable "Console lock display off timeout" under "Power Options / Advanced Settings / Display".
        Registry LockDisplayConfigSectionEnabled {
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\7516b95f-f776-4464-8c53-06167f40cc99\8EC4B3A5-6868-48c2-BE75-4F3044BE88A7'
            ValueName = 'Attributes'
            Ensure    = 'Present'
            ValueType = 'Dword'
            ValueData = '2'
        }

        # Set inactivity timeout. This turns off the screen after a period of inactivity but does not lock it.
        # To lock the screen set the screen saver registry settings in UserConfiguration.ps1.
        Registry InactivityTimeout {
            Key       = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'InactivityTimeoutSecs'
            Ensure    = 'Present'
            ValueType = 'Dword'
            ValueData = '300'
        }

        # Disable fast boot.
        Registry FastBoot {
            Key       = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
            ValueName = 'HiberbootEnabled'
            Ensure    = 'Present'
            ValueType = 'Dword'
            ValueData = '0'
        }

        # Enable Hyper V - Requires Windows Pro
        WindowsOptionalFeature EnableHyperV {
            Name   = 'Microsoft-Hyper-V-All'
            Ensure = 'Enable'
        }

        # Enable Hypervisor Platform. Allows Docker and other 3rd party virtualization applications.
        WindowsOptionalFeature EnableHypervisorPlatform {
            Name   = 'HypervisorPlatform'
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
