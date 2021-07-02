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

    Write-Host $command

    $encoded = ConvertTo-Base64Encoding $command

    Write-Host "encoded: $encoded"

    wsl watch --color --interval $Interval "'/mnt/c/Program Files/PowerShell/7/pwsh.exe' -e '$encoded' -o Text"
}