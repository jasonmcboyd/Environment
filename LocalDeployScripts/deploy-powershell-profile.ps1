$profilePath = Split-Path $profile.CurrentUserAllHosts

Copy-Item -Path "$PSScriptRoot/../PowerShellProfiles/CurrentUserAllHosts/*" -Destination $profilePath -Recurse -Force
