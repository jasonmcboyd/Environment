function Get-BinObjFolder {
  [CmdletBinding()]
  param ()

  Get-ChildItem -Recurse -Directory | Where-Object { $_.Name -match '^(bin|obj)$' }
}

function Remove-BinObjFolder {
  [CmdletBinding()]
  param ()

  Get-BinObjFolder | Remove-Item -Recurse -Force
}
