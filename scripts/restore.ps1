# Claude Config Restore Script (Windows)
# Copies config from repo to ~/.claude

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ConfigDir = Join-Path $RepoRoot "config"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "🔄 Restoring Claude config from repository..." -ForegroundColor Cyan

# Create ~/.claude if it doesn't exist
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "📁 Creating $ClaudeDir directory..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
}

# Restore settings.json
$SettingsFile = Join-Path $ConfigDir "settings.json"
if (Test-Path $SettingsFile) {
    Write-Host "📄 Restoring settings.json..." -ForegroundColor Green
    Copy-Item $SettingsFile (Join-Path $ClaudeDir "settings.json") -Force
} else {
    Write-Host "⚠️  Warning: settings.json not found in repo" -ForegroundColor Yellow
}

# Restore hooks directory
$ConfigHooksDir = Join-Path $ConfigDir "hooks"
if ((Test-Path $ConfigHooksDir) -and ((Get-ChildItem $ConfigHooksDir -ErrorAction SilentlyContinue).Count -gt 0)) {
    Write-Host "🪝 Restoring hooks..." -ForegroundColor Green
    $HooksDir = Join-Path $ClaudeDir "hooks"
    New-Item -ItemType Directory -Path $HooksDir -Force | Out-Null
    Copy-Item "$ConfigHooksDir\*" $HooksDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "⚠️  Warning: hooks directory empty or not found in repo" -ForegroundColor Yellow
}

# Restore skills directory
$ConfigSkillsDir = Join-Path $ConfigDir "skills"
if ((Test-Path $ConfigSkillsDir) -and ((Get-ChildItem $ConfigSkillsDir -ErrorAction SilentlyContinue).Count -gt 0)) {
    Write-Host "🎯 Restoring skills..." -ForegroundColor Green
    $SkillsDir = Join-Path $ClaudeDir "skills"
    New-Item -ItemType Directory -Path $SkillsDir -Force | Out-Null
    Copy-Item "$ConfigSkillsDir\*" $SkillsDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "⚠️  Warning: skills directory empty or not found in repo" -ForegroundColor Yellow
}

Write-Host "`n✅ Restore complete!" -ForegroundColor Green
Write-Host "`nYour Claude configuration has been restored to $ClaudeDir"
