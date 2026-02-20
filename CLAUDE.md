# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Personal workstation environment configuration packaged as Chocolatey packages. Configuration files (PowerShell profile, Starship prompt, Vim, Windows Terminal) are versioned here, published as GitHub Releases, then packaged as Chocolatey `.nupkg` files and pushed to a private Azure DevOps NuGet feed.

## Architecture

### Four independent packages

Each maps a source directory to a Chocolatey package:

| Source Directory | Package Name | Installs To |
|---|---|---|
| `PowerShellProfiles/CurrentUserAllHosts/` | `environment-powershell-core-profile` | `$USERPROFILE/Documents/PowerShell/Imports/Personal/` |
| `Starship/` | `environment-starship-config` | `$HOME/.starship/` |
| `Vim/` | `environment-vim-config` | `$USERPROFILE/.vimrc` and `.viemurc` |
| `WindowsTerminal/` | `environment-windows-terminal-settings` | Windows Terminal LocalState directory |

### Publishing pipeline

Triggered by push to master or manual dispatch via `publish-all.yml`:

1. **publish-release.yml** — Zips the source directory, compares folder hash against latest GitHub Release. Creates a new release only if content changed.
2. **publish-chocolatey-package.yml** — Downloads the GitHub Release, generates a dynamic install script with the release URL and SHA256 checksum, packs the `.nupkg`, and pushes to Azure DevOps.

Version logic (`Publish/PowerShellScripts/CreateNuGetPackage.ps1`):
- Release major version > package major version → use release version
- Same major version, different hash → bump minor version
- Same hash → skip (no material change)

### PowerShell profile structure

`profile.ps1` recursively dot-sources all `.ps1` files under `Imports/Personal/`. Load order is filesystem enumeration order. Git-related scripts handle their own internal dependencies via explicit dot-sourcing in `git/git.ps1`.

### Local deployment

`LocalDeployScripts/deploy-powershell-profile.ps1` uses `robocopy /MIR` to mirror the profile source to the local PowerShell profile directory. This deletes files removed from the repo — the `Imports/Personal/` directory is exclusively owned by this repo.

### DSC (Desired State Configuration)

`DSC/` contains system-level and user-level configurations for initial workstation provisioning (Hyper-V, WSL, Chocolatey packages, UI preferences). These are bootstrap scripts, not regularly modified.

## Conventions

- All PowerShell scripts use `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'`.
- Profile functions use `[CmdletBinding()]` and support pipeline input where appropriate.
- Elevation is handled via `gsudo` (aliased as `sudo`). Pass variables into elevated script blocks using `param()` and `-args`, not `$using:`.
- This is a public repo. Avoid hardcoding personal information (email addresses, Azure DevOps URLs). The source URL for the Chocolatey feed is read dynamically from `choco sources list` at runtime.
