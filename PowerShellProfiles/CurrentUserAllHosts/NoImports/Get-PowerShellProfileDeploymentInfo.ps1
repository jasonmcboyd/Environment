[CmdletBinding()]
param (
    [string]
    $Branch = 'master'
)

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$directoryStructure = & "$PSScriptRoot/Get-GitHubDirectoryStructure.ps1" -Branch $Branch

$remotePaths = $directoryStructure.tree.path | Where-Object { $_ -like '*PowerShellProfiles/CurrentUserAllHosts/*.ps1' }
$localProfileDirectory = Split-Path $profile.CurrentUserAllHosts

foreach ($remotePath in $remotePaths) {
    [PSCustomObject]@{
        Url = "$rootUrl/$remotePath"
        Destination = "$localProfileDirectory\$($remotePath.Replace('PowerShellProfiles/CurrentUserAllHosts/', '').Replace('/', '\'))"
    }
}
