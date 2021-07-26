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
