function Import-EnvironmentSettings {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master',

        [switch]
        $PowerShell,

        [switch]
        $Vim,

        [switch]
        $WindowsTerminal
    )

    $all = !$PowerShell -and !$Vim -and !$WindowsTerminal
    Write-Debug "all: $all"

    $noImportsDirectory = Get-Item "$PSScriptRoot/../NoImports" | Select-Object -ExpandProperty FullName

    $deploymentInfos = @()

    if ($all -or $PowerShell) {
        $deploymentInfos += & "$noImportsDirectory/Get-PowerShellProfileDeploymentInfo.ps1" -Branch $Branch
    }

    if ($all -or $Vim) {
        $deploymentInfos += & "$noImportsDirectory/Get-VimDeploymentInfo.ps1" -Branch $Branch
    }

    if ($all -or $WindowsTerminal) {
        $deploymentInfos += & "$noImportsDirectory/Get-WindowsTerminalDeploymentInfo.ps1" -Branch $Branch
    }

    $remoteFileHashes = & "$noImportsDirectory/Get-RemoteFileHashes.ps1" -Branch $Branch
    $rootUrl = & "$noImportsDirectory/Get-GitHubRootUrl.ps1" -Branch $Branch

    foreach ($deploymentInfo in $deploymentInfos) {
        $hashesMatch = `
            & "$noImportsDirectory/Compare-FileHash.ps1" `
            -FilePath $deploymentInfo.Destination `
            -Key $deploymentInfo.Url.Replace($rootUrl, '') `
            -RemoteFileHashes $RemoteFileHashes

        if ($hashesMatch) {
            Write-Verbose "Deploying $($deploymentInfo.Destination)..."
        }
        else {
            Write-Verbose "Skipping $(deploymentInfo.Destination)..."
        }

        # if (!$hashesMatch) {
        #     Write-Verbose "Downloading $url"
        #     Invoke-WebRequest $url -OutFile "$destination"

        #     foreach ($targetDirectory in $targetDirectories | Select-Object -Skip 1) {
        #         Copy-Item $destination "$targetDirectory/$file"
        #     }
        # }
    }
}
