[CmdletBinding()]
[OutputType([Hashtable])]
param (
  [string]
  [Parameter(Mandatory = $true)]
  $ReleasePrefix,

  [string]
  [Parameter(Mandatory = $true)]
  $ReleaseDownloadUrl,

  [Version]
  [Parameter(Mandatory = $true)]
  $ReleaseVersion,

  [string]
  [Parameter(Mandatory = $true)]
  $ReleaseFileHash,

  [Version]
  [Parameter(Mandatory = $true)]
  $PackageVersion,

  [string]
  [Parameter(Mandatory = $true)]
  $PackageFileHash
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageName = "environment-$ReleasePrefix"

Push-Location -Path "./Publish/NuGet/$packageName"

try {
  mkdir /working/tools | Out-Null

  Copy-Item ./*.nuspec /working | Out-Null

  $installScript =
    ./createChocolateyInstallScript.ps1 `
      -ReleaseUrl $ReleaseDownloadUrl `
      -ReleaseFileHash $ReleaseFileHash

  Set-Content -Path /working/tools/chocolateyInstall.ps1 -Value $installScript

  Set-Location /working

  # If the release version is greater than the chocolatey version we are creating a new NuGet
  # package automatically.
  if ($ReleaseVersion.Major -gt $PackageVersion.Major) {
    $version = $ReleaseVersion.ToString()
    choco pack "./$packageName.nuspec" --version=$version | Out-Null
  }
  # If the release major version is the same as the chocolatey version we will create a new package
  # using the old chocolatey version and then we will check the new package's file hash against the old
  # package's file hash. We have to use the old package version because the version number is an input
  # into the package; using the new version number will create a new nuspec file which will result in a new
  # hash even if everything else remained unchanged.
  elseif ($ReleaseVersion.Major -eq $PackageVersion.Major) {
    $version = $PackageVersion.ToString()
    choco pack "./$packageName.nuspec" --version=$version | Out-Null
    $nupkgFileName = "$packageName.$version.nupkg"
    $fileHash = (Get-FileHash -Path $nupkgFileName).Hash

    # If the file hash's do not match then that means we have a material change and we should
    # build the NuGet package with the correct version.
    if ($fileHash -ne $PackageFileHash) {
      $version = [Version]::new($PackageVersion.Major, $PackageVersion.Minor + 1, 0)
      choco pack "./$packageName.nuspec" --version=$version | Out-Null
    }
  }
  else {
    throw "The release major version should never be less than the package major version. Something has gone terribly wrong."
  }

  $nupkgFileName = "$packageName.$version.nupkg"
  Move-Item $nupkgFilePath $HOME | Out-Null
  $fileHash = (Get-FileHash -Path "$HOME/$nupkgFileName").Hash

  @{
    PackagePath = "$HOME/$nupkgFileName"
    FileHash    = $fileHash
  }
}
finally {
  Pop-Location
  if (Test-Path /working) {
    Remove-Item /working -Recurse
  }
}
