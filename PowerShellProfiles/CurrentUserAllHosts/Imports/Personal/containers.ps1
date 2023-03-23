function dhere {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Image,

    [Parameter()]
    [string]
    $Command,

    [switch]
    $Write
  )

  $dockerCommand = "docker run -it --rm -v '$(Get-Location):/wrk:$(if ($Write) { 'rw' } else { 'ro' })' -w '/wrk' $Image $Command"

  Write-Debug "dockerCommand: $dockerCommand"

  Invoke-Expression $dockerCommand
}

Set-Alias -Name k -Value kubectl
