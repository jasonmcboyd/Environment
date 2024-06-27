function ConvertTo-Base64Encoding {
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]]
    $Value,

    [System.Text.Encoding]
    $Encoding = [System.Text.Encoding]::UTF8
  )

  Process {
    foreach ($val in $Value) {
      [Convert]::ToBase64String($Encoding.GetBytes($val))
    }
  }
}

function ConvertFrom-Base64Encoding {
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]]
    $Value,

    [System.Text.Encoding]
    $Encoding = [System.Text.Encoding]::UTF8
  )

  Process {
    foreach ($val in $Value) {
      $Encoding.GetString([System.Convert]::FromBase64String($val))
    }
  }
}
