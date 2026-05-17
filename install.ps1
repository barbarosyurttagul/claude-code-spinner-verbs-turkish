#Requires -Version 5.1
<#
.SYNOPSIS
    Installs Turkish spinner verbs for Claude Code.
.DESCRIPTION
    Downloads spinner-verbs.json and merges it into ~/.claude/settings.json.
#>

$ErrorActionPreference = 'Stop'

$VerbsUrl     = 'https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/spinner-verbs.json'
$SettingsDir  = Join-Path $env:USERPROFILE '.claude'
$SettingsFile = Join-Path $SettingsDir 'settings.json'

function Write-Info  { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Green }
function Write-Warn  { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Yellow }
function Write-Err   { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Red }

# Fetch verbs
Write-Info 'Fetching Turkish spinner verbs...'
try {
    $VerbsData = Invoke-RestMethod -Uri $VerbsUrl -UseBasicParsing
} catch {
    Write-Err "Failed to download verbs: $_"
    exit 1
}

$SpinnerVerbs = $VerbsData.spinnerVerbs

# Create settings dir if needed
if (-not (Test-Path $SettingsDir)) {
    New-Item -ItemType Directory -Path $SettingsDir | Out-Null
}

if (-not (Test-Path $SettingsFile)) {
    # No existing settings — write fresh
    $NewSettings = [PSCustomObject]@{ spinnerVerbs = $SpinnerVerbs }
    $NewSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
    Write-Info "Created $SettingsFile with Turkish spinner verbs."
} else {
    Write-Warn "Existing settings file found at $SettingsFile"
    Write-Host ''
    Write-Host '  [m] Merge    - replace only spinnerVerbs, keep all other settings'
    Write-Host '  [o] Overwrite - replace entire settings file'
    Write-Host '  [c] Cancel'
    Write-Host ''
    $Choice = Read-Host 'Choose an option [m/o/c]'

    switch ($Choice.ToLower()) {
        'm' {
            $Backup = "$SettingsFile.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $SettingsFile $Backup
            Write-Warn "Backed up existing settings to $Backup"

            $Existing = Get-Content $SettingsFile -Raw | ConvertFrom-Json
            $Existing | Add-Member -MemberType NoteProperty -Name 'spinnerVerbs' -Value $SpinnerVerbs -Force
            $Existing | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
            Write-Info "Merged Turkish spinner verbs into $SettingsFile"
        }
        'o' {
            $Backup = "$SettingsFile.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $SettingsFile $Backup
            Write-Warn "Backed up existing settings to $Backup"

            $NewSettings = [PSCustomObject]@{ spinnerVerbs = $SpinnerVerbs }
            $NewSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
            Write-Info "Overwrote $SettingsFile with Turkish spinner verbs."
        }
        'c' {
            Write-Info 'Cancelled. No changes made.'
            exit 0
        }
        default {
            Write-Err 'Invalid choice. Aborting.'
            exit 1
        }
    }
}

Write-Info 'Done! Restart Claude Code to see Turkish verbs in action.'
