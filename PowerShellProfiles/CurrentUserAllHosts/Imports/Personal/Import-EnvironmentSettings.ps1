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

  $noImportsDirectory = Get-Item "$PSScriptRoot/../../NoImports" | Select-Object -ExpandProperty FullName

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

  if ($deploymentInfos.Length -eq 0) {
    Write-Verbose "Nothing to deploy."
    return
  }

  $remoteFileHashes = & "$noImportsDirectory/Get-RemoteFileHashes.ps1" -Branch $Branch
  $rootUrl = & "$noImportsDirectory/Get-GitHubRootUrl.ps1" -Branch $Branch

  foreach ($deploymentInfo in $deploymentInfos) {
    $hashesMatch = `
      & "$noImportsDirectory/Compare-FileHash.ps1" `
      -FilePath $deploymentInfo.Destination `
      -Key $deploymentInfo.Url.Replace($rootUrl, '') `
      -LineEnding $deploymentInfo.LineEnding `
      -RemoteFileHashes $RemoteFileHashes

    if (!$hashesMatch) {
      Write-Verbose "Deploying $($deploymentInfo.Destination)..."

      $fileContent = (Invoke-WebRequest $deploymentInfo.Url).Content

      if ($deploymentInfo.LineEnding -eq 'CRLF') {
        $fileContent = $fileContent -replace "`n", "`r`n"
      }

      $destinationDirectory = $deploymentInfo.Destination | Split-Path

      if (!(Test-Path $destinationDirectory)) {
        Write-Debug "Creating destination directory..."
        New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
      }

      Set-Content -Path $deploymentInfo.Destination -Value $fileContent -NoNewLine
    }
    else {
      Write-Verbose "Skipping $($deploymentInfo.Destination)..."
    }
  }
}
