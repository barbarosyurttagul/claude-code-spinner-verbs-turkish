#Requires -Version 5.1
<#
.SYNOPSIS
    Claude Code için Türkçe spinner fiillerini kurar.
.DESCRIPTION
    spinner-verbs.json dosyasını indirir ve ~/.claude/settings.json dosyasına ekler.
#>

$ErrorActionPreference = 'Stop'

$VerbsUrl     = 'https://raw.githubusercontent.com/barbarosyurttagul/claude-code-spinner-verbs-turkish/refs/heads/master/spinner-verbs.json'
$SettingsDir  = Join-Path $env:USERPROFILE '.claude'
$SettingsFile = Join-Path $SettingsDir 'settings.json'

function Write-Info  { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Green }
function Write-Warn  { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Yellow }
function Write-Err   { param($Msg) Write-Host "[turkish-verbs] $Msg" -ForegroundColor Red }

# Fetch verbs
Write-Info 'GitHub''dan son fiiller çekiliyor...'
try {
    $VerbsData = Invoke-RestMethod -Uri $VerbsUrl -UseBasicParsing
} catch {
    Write-Err "Fiiller indirilemedi: $_"
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
    Write-Info "Türkçe spinner fiiilleriyle $SettingsFile oluşturuldu."
} else {
    Write-Warn "Mevcut ayar dosyası bulundu: $SettingsFile"
    Write-Host ''
    Write-Host '  [m] Birleştir  - diğer ayarları koru, sadece spinnerVerbs''i değiştir'
    Write-Host '  [o] Üstüne yaz - tüm dosyayı Türkçe fiillerle değiştir'
    Write-Host '  [c] İptal'
    Write-Host ''
    $Choice = Read-Host 'Ne yapalım? [m/o/c]'

    switch ($Choice.ToLower()) {
        'm' {
            $Backup = "$SettingsFile.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $SettingsFile $Backup
            Write-Warn "Mevcut ayarlar yedeklendi: $Backup"

            $Existing = Get-Content $SettingsFile -Raw | ConvertFrom-Json
            $Existing | Add-Member -MemberType NoteProperty -Name 'spinnerVerbs' -Value $SpinnerVerbs -Force
            $Existing | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
            Write-Info "Türkçe spinner fiiilleri $SettingsFile dosyasına eklendi."
        }
        'o' {
            $Backup = "$SettingsFile.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $SettingsFile $Backup
            Write-Warn "Mevcut ayarlar yedeklendi: $Backup"

            $NewSettings = [PSCustomObject]@{ spinnerVerbs = $SpinnerVerbs }
            $NewSettings | ConvertTo-Json -Depth 10 | Set-Content -Path $SettingsFile -Encoding UTF8
            Write-Info "$SettingsFile Türkçe spinner fiilleriyle değiştirildi."
        }
        'c' {
            Write-Info 'İptal edildi. Hiçbir şey değiştirilmedi.'
            exit 0
        }
        default {
            Write-Err 'Geçersiz seçim. Duruyorum.'
            exit 1
        }
    }
}

Write-Info 'Tamam. Yeni spinner''ı görmek için Claude Code''u yeniden başlat.'
