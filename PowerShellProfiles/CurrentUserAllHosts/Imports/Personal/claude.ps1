function Remove-Nul {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param ()

  $currentPath = (Get-Location).Path
  $targetPath = Join-Path $currentPath 'nul'
  $extended = "\\?\$targetPath"

  if (-not (Test-Path -LiteralPath $extended)) {
    Write-Verbose "No file named 'nul' found in $currentPath"
    return
  }

  if ($PSCmdlet.ShouldProcess($targetPath, "Remove literal file named 'nul'")) {
    try {
      Remove-Item -LiteralPath $extended -Force -ErrorAction Stop
      Write-Host "Removed file: $targetPath"
    }
    catch {
      Write-Error "Failed to remove '$targetPath' : $_"
    }
  }
}
