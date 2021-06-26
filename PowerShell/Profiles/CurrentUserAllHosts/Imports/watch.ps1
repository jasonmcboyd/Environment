function watch {
	param (
		[scriptblock]
		$ScriptBlock,

		[int]
		$Interval = 2
	)

	wsl watch --color --interval $Interval "'/mnt/c/Program Files/PowerShell/7/pwsh.exe' -C '$ScriptBlock'"
}