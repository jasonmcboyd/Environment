# Function to expand single property of an object, i.e. alias for Select-Object -ExpandProperty
function Prop {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $true)]
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

function Start-Presentation {
  [CmdletBinding()]
  param (
      $Seconds = 30
  )

  Start-Job `
    -Name 'Presentation Mode' `
    -ScriptBlock {
      $myShell = New-Object -com "Wscript.Shell"

      while ($true) {
        Start-Sleep -Seconds $Seconds
        $myShell.sendkeys("{F13}")
      }
    }
}

function Get-Presentation {
  [CmdletBinding()]
  param ()

  Get-Job -Name 'Presentation Mode'
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
