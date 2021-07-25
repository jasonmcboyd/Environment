[CmdletBinding()]
param (
    [string]
    $Branch = 'master',

    $RemoteFileHashes
)

$targetDirectories = [System.Collections.Generic.HashSet[string]]::new()
$targetDirectories.Add($HOME) | Out-Null

if (Test-Path Env:\HOME) {
    $path = $env:HOME

    Write-Debug "Env:\HOME exists, path is $path."

    $targetDirectories.Add($path) | Out-Null
}
elseif ((Test-Path Env:\HOMEDRIVE) -and (Test-Path Env:\HOMEPATH)) {
    $path = Join-Path $env:HOMEDRIVE $env:HOMEPATH

    Write-Debug "Env:\HOMEDRIVE and Env:\HOMEPATH exists, path is $path."

    $targetDirectories.Add($path) | Out-Null
}

Write-Debug "targetDirectories:`r`n$targetDirectories"
Write-Debug $targetDirectories.Length

if ($targetDirectories.Length -eq 0) {
    throw "No target directories defined"
}

$rootUrl = & "$PSScriptRoot/Get-GitHubRootUrl.ps1" -Branch $Branch
$files = @('.vimrc', '.viemurc')

foreach ($file in $files) {
    $url = "$rootUrl/Vim/$file"
    Write-Debug "url: $url"

    $destination = "$($targetDirectories[0])/$file"
    Write-Debug "destination: $destination"

    $hashesMatch =
        & "$PSScriptRoot/Compare-FileHash.ps1" `
        -Branch $Branch `
        -FilePath $destination `
        -GitHubUrl $url `
        -RemoteFileHashes $RemoteFileHashes

    if (!$hashesMatch) {
        Write-Verbose "Downloading $url"
        Invoke-WebRequest $url -OutFile "$destination"

        foreach ($targetDirectory in $targetDirectories | Select-Object -Skip 1) {
            Copy-Item $destination "$targetDirectory/$file"
        }
    }
}
