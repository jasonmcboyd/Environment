function ConvertTo-Base64Encoding {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Value
    )

    Process {
        foreach ($val in $Value) {
            [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($val))
        }
    }
}

function ConvertFrom-Base64Encoding {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Value
    )

    Process {
        foreach ($val in $Value) {
            [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($val))
        }
    }
}
