function Import-ProfileFromGitHub {
    [CmdletBinding()]
    param (
        [string]
        $Branch = 'master'
    )

    $url = "https://api.github.com/repos/jasonmcboyd/Environment/git/trees/$Branch`?recursive=1"
    Write-Debug "url: $url"

    $remoteImportsDirectory = 'PowerShellProfiles/CurrentUserAllHosts/Imports'
    $remoteNoImportsDirectory = 'PowerShellProfiles/CurrentUserAllHosts/NoImports'
    $localProfileDirectory = Split-Path $profile.CurrentUserAllHosts
    $localImportsDirectory = Join-Path $localProfileDirectory 'Imports/Personal'
    $localNoImportsDirectory = Join-Path $localProfileDirectory 'NoImports'

    Write-Debug "localImportsDirectory: $localImportsDirectory"
    Write-Debug "localNoImportsDirectory: $localNoImportsDirectory"

    if (!(Test-Path $localImportsDirectory)) {
        Write-Verbose "Creatimg local Imports directory..."
        mkdir $localImportsDirectory
    }

    if (!(Test-Path $localNoImportsDirectory)) {
        Write-Verbose "Creatimg local NoImports directory..."
        mkdir $localNoImportsDirectory
    }

    $directoryStructure = `
        Invoke-WebRequest $url `
        | Select-Object -ExpandProperty Content `
        | ConvertFrom-Json

    Invoke-WebRequest "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/PowerShellProfiles/CurrentUserAllHosts/profile.ps1" -OutFile $profile.CurrentUserAllHosts

    $filesToImport = $directoryStructure.tree.path | Where-Object { $_ -like "$remoteImportsDirectory/*.ps1" }

    foreach ($fileToImport in $filesToImport) {
        $filename = Split-Path -Path $fileToImport -Leaf
        $destination = Join-Path $localImportsDirectory $filename
        Write-Debug "destination: $destination"

        $url = "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/$remoteImportsDirectory/$filename"
        Write-Debug "url: $url"

        Invoke-WebRequest -Uri $url -OutFile $destination
    }

    $filesToImport = $directoryStructure.tree.path | Where-Object { $_ -like "$remoteNoImportsDirectory/*.ps1" }

    foreach ($fileToImport in $filesToImport) {
        $filename = Split-Path -Path $fileToImport -Leaf
        $destination = Join-Path $localNoImportsDirectory $filename
        Write-Debug "destination: $destination"

        $url = "https://raw.githubusercontent.com/jasonmcboyd/Environment/$Branch/$remoteNoImportsDirectory/$filename"
        Write-Debug "url: $url"

        Invoke-WebRequest -Uri $url -OutFile $destination
    }
}
