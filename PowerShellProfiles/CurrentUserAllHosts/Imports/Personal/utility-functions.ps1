# Function to expand single property of an object, i.e. alias for Select-Object -ExpandProperty
function Prop {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Property,

    [parameter(ValueFromPipeline = $true)]
    [object[]]
    $InputObject)

  Begin {
    if ([string]::IsNullOrWhiteSpace($Property)) {
      throw [System.ArgumentException]::("Invalid property name")
    }
  }
  Process {
    foreach ($obj in $InputObject) {
      Select-Object -InputObject $obj -ExpandProperty $Property
    }
  }
}

function WhatIs {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string]
    $Command)

  $count = 1

  $c = Get-Command $Command

  while ($c.CommandType -eq 'Alias') {
    Write-Output ([PSCustomObject]@{
      CommandCount = $count
      Name         = $c.Name
      Type         = $c.CommandType
      Definition   = $c.Definition
    })

    $c = Get-Command $c.Definition
    $count++
  }

  Write-Output ([PSCustomObject]@{
    CommandCount = $count
    Name         = $c.Name
    Type         = $c.CommandType
    Definition   = $c.Definition
  })
}

function Any {
  [CmdletBinding()]
  param (
    [parameter(ValueFromPipeline = $true)]
    [object[]]
    $InputObject
  )

  if ($null -eq $InputObject) {
    return $false
  }

  ($InputObject | Select-Object -First 1).Count -gt 0
}

function Guid {
  New-Guid | Set-Clipboard -PassThru
}

function To {
  [CmdletBinding()]
  param (
    [string]
    $Variable,

    [Parameter(ValueFromPipeline = $true)]
    [PsObject]
    $InputObject
  )

  process {
    Set-Variable -Name $Variable -Scope Global -Value $InputObject

    $InputObject
  }
}

function Touch {
  [CmdletBinding()]
  param (
    [parameter(ValueFromPipeline = $true)]
    [string[]]
    $Path
  )

  Process {
    foreach ($p in $Path) {
      if (-not (Test-Path $Path)) {
        Write-Debug "Path does not exist, creating it."
        Set-Content -Path $Path -Value ''
      }
      else {
        Write-Debug "Path exists, updating timestamp."
        (Get-Item -Path $Path).LastWriteTime = Get-Date
      }
    }
  }
}

function Tail {
  [CmdletBinding()]
  param (
    [parameter(ValueFromPipeline = $true)]
    [string]
    $Path,

    [int]
    $Count
  )

  if (-not (Test-Path $Path)) {
    Touch $Path
  }

  if ($Count -gt 0) {
    Get-Content -Path $Path -Tail $Count -Wait
  }
  else {
    Get-Content -Path $Path -Wait
  }
}
