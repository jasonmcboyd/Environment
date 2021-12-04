function dhere {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Image
  )

  & docker run -it --rm -v "$(Get-Location):/wrk:ro" -w '/wrk' $Image
}

Set-Alias -Name k -Value kubernetes
