$profilePath = Split-Path $profile.CurrentUserAllHosts
$sourcePath = "$PSScriptRoot/../PowerShellProfiles/CurrentUserAllHosts"

robocopy $sourcePath $profilePath /MIR /NJH /NJS
