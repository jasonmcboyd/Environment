function New-SqlContainer {
  [CmdletBinding()]
  param (
    [string]
    $ContainerName,

    [int]
    $Port = 1433,

    [SecureString]
    $Password
  )

  $ErrorActionPreference = 'Stop'
  Set-StrictMode -Version Latest

  $command = "docker run $([string]::IsNullOrWhiteSpace($ContainerName) ? '' : "--name=$ContainerName") -d -e `"ACCEPT_EULA=Y`" -e `"MSSQL_SA_PASSWORD=$($null -eq $Password ? 'Password1' : (ConvertFrom-SecureString -SecureString $Password -AsPlainText))`" -p $($Port):1433 mcr.microsoft.com/mssql/server:2022-latest"

  Write-Debug "Command: $command"

  Invoke-Expression $command
}
