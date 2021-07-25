[CmdletBinding()]
param (
    [string]
    $Branch = 'master',

    $RemoteFileHashes
)

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

$directoryUrl = "https://api.github.com/repos/jasonmcboyd/Environment/git/trees/$Branch`?recursive=1"
Write-Debug "directoryUrl: $directoryUrl"

$directoryStructure = `
    Invoke-WebRequest $directoryUrl `
    | Select-Object -ExpandProperty Content `
    | ConvertFrom-Json

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
Invoke-WebRequest "$rootUrl/PowerShellProfiles/CurrentUserAllHosts/profile.ps1" -OutFile $profile.CurrentUserAllHosts

$filesToImport = $directoryStructure.tree.path | Where-Object { $_ -like "$remoteImportsDirectory/*.ps1" }

foreach ($fileToImport in $filesToImport) {
    $filename = Split-Path -Path $fileToImport -Leaf
    $destination = Join-Path $localImportsDirectory $filename
    Write-Debug "destination: $destination"

    $url = "$rootUrl/$remoteImportsDirectory/$filename"
    Write-Debug "url: $url"

    Invoke-WebRequest -Uri $url -OutFile $destination
}

$filesToImport = $directoryStructure.tree.path | Where-Object { $_ -like "$remoteNoImportsDirectory/*.ps1" }

foreach ($fileToImport in $filesToImport) {
    $filename = Split-Path -Path $fileToImport -Leaf
    $destination = Join-Path $localNoImportsDirectory $filename
    Write-Debug "destination: $destination"

    $url = "$rootUrl/$remoteNoImportsDirectory/$filename"
    Write-Debug "url: $url"

    Invoke-WebRequest -Uri $url -OutFile $destination
}
