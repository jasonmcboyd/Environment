function watch {
  param (
    [scriptblock]
    $ScriptBlock,

    [int]
    $Interval = 2
  )

  $command = @"
        Write-Host '$($ScriptBlock.ToString())'
        Write-Host ''
        $($ScriptBlock.ToString())
"@

  $encoded = ConvertTo-Base64Encoding $command

  wsl watch --color --interval $Interval "'/mnt/c/Program Files/PowerShell/7/pwsh.exe' -e '$encoded' -o Text"
}
