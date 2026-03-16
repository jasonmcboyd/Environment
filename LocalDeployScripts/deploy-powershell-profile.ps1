$profileRoot = Split-Path $profile.CurrentUserAllHosts
$repoRoot = "$PSScriptRoot/../PowerShellProfiles/CurrentUserAllHosts"

robocopy "$repoRoot/Imports/Personal" "$profileRoot/Imports/Personal" /MIR /NJH /NJS /NFL /NDL /NP
Copy-Item "$repoRoot/profile.ps1" $profile.CurrentUserAllHosts -Force
