# Claude Config Backup Script (Windows)
# Copies config from ~/.claude to repo

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$ConfigDir = Join-Path $RepoRoot "config"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "🔄 Backing up Claude config to repository..." -ForegroundColor Cyan

# Check if ~/.claude exists
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "❌ Error: $ClaudeDir directory not found" -ForegroundColor Red
    exit 1
}

# Backup settings.json
$SettingsFile = Join-Path $ClaudeDir "settings.json"
if (Test-Path $SettingsFile) {
    Write-Host "📄 Backing up settings.json..." -ForegroundColor Green
    Copy-Item $SettingsFile (Join-Path $ConfigDir "settings.json") -Force
} else {
    Write-Host "⚠️  Warning: settings.json not found in $ClaudeDir" -ForegroundColor Yellow
}

# Backup hooks directory
$HooksDir = Join-Path $ClaudeDir "hooks"
if (Test-Path $HooksDir) {
    Write-Host "🪝 Backing up hooks..." -ForegroundColor Green
    $ConfigHooksDir = Join-Path $ConfigDir "hooks"
    if (Test-Path $ConfigHooksDir) {
        Remove-Item $ConfigHooksDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $ConfigHooksDir -Force | Out-Null
    Copy-Item "$HooksDir\*" $ConfigHooksDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "⚠️  Warning: hooks directory not found in $ClaudeDir" -ForegroundColor Yellow
}

# Backup skills directory
$SkillsDir = Join-Path $ClaudeDir "skills"
if (Test-Path $SkillsDir) {
    Write-Host "🎯 Backing up skills..." -ForegroundColor Green
    $ConfigSkillsDir = Join-Path $ConfigDir "skills"
    if (Test-Path $ConfigSkillsDir) {
        Remove-Item $ConfigSkillsDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $ConfigSkillsDir -Force | Out-Null
    Copy-Item "$SkillsDir\*" $ConfigSkillsDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "⚠️  Warning: skills directory not found in $ClaudeDir" -ForegroundColor Yellow
}

Write-Host "`n✅ Backup complete!" -ForegroundColor Green
Write-Host "`nNext steps:"
Write-Host "  git status              # Review changes"
Write-Host "  git add config/         # Stage changes"
Write-Host "  git commit -m 'Update config'  # Commit changes"
Write-Host "  git push                # Push to remote"
