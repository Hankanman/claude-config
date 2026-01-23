#!/usr/bin/env bash
set -euo pipefail

# Claude Config Restore Script
# Copies config from repo to ~/.claude

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="$REPO_ROOT/config"
CLAUDE_DIR="$HOME/.claude"

echo "🔄 Restoring Claude config from repository..."

# Create ~/.claude if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "📁 Creating ~/.claude directory..."
    mkdir -p "$CLAUDE_DIR"
fi

# Restore settings.json
if [ -f "$CONFIG_DIR/settings.json" ]; then
    echo "📄 Restoring settings.json..."
    cp "$CONFIG_DIR/settings.json" "$CLAUDE_DIR/settings.json"
else
    echo "⚠️  Warning: settings.json not found in repo"
fi

# Restore hooks directory
if [ -d "$CONFIG_DIR/hooks" ] && [ -n "$(ls -A "$CONFIG_DIR/hooks" 2>/dev/null)" ]; then
    echo "🪝 Restoring hooks..."
    mkdir -p "$CLAUDE_DIR/hooks"
    cp -r "$CONFIG_DIR/hooks/"* "$CLAUDE_DIR/hooks/" 2>/dev/null || true
    # Make hook scripts executable
    find "$CLAUDE_DIR/hooks" -type f -name "*.sh" -exec chmod +x {} \;
else
    echo "⚠️  Warning: hooks directory empty or not found in repo"
fi

# Restore skills directory
if [ -d "$CONFIG_DIR/skills" ] && [ -n "$(ls -A "$CONFIG_DIR/skills" 2>/dev/null)" ]; then
    echo "🎯 Restoring skills..."
    mkdir -p "$CLAUDE_DIR/skills"
    cp -r "$CONFIG_DIR/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
else
    echo "⚠️  Warning: skills directory empty or not found in repo"
fi

echo "✅ Restore complete!"
echo ""
echo "Your Claude configuration has been restored to ~/.claude"
