#!/usr/bin/env bash
set -euo pipefail

# Claude Config Backup Script
# Copies config from ~/.claude to repo

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="$REPO_ROOT/config"
CLAUDE_DIR="$HOME/.claude"

echo "🔄 Backing up Claude config to repository..."

# Check if ~/.claude exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ Error: ~/.claude directory not found"
    exit 1
fi

# Backup settings.json
if [ -f "$CLAUDE_DIR/settings.json" ]; then
    echo "📄 Backing up settings.json..."
    cp "$CLAUDE_DIR/settings.json" "$CONFIG_DIR/settings.json"
else
    echo "⚠️  Warning: settings.json not found in ~/.claude"
fi

# Backup hooks directory
if [ -d "$CLAUDE_DIR/hooks" ]; then
    echo "🪝 Backing up hooks..."
    rm -rf "$CONFIG_DIR/hooks"
    mkdir -p "$CONFIG_DIR/hooks"
    cp -r "$CLAUDE_DIR/hooks/"* "$CONFIG_DIR/hooks/" 2>/dev/null || true
else
    echo "⚠️  Warning: hooks directory not found in ~/.claude"
fi

# Backup skills directory (user-created only, not plugin cache)
if [ -d "$CLAUDE_DIR/skills" ]; then
    echo "🎯 Backing up skills..."
    rm -rf "$CONFIG_DIR/skills"
    mkdir -p "$CONFIG_DIR/skills"
    cp -r "$CLAUDE_DIR/skills/"* "$CONFIG_DIR/skills/" 2>/dev/null || true
else
    echo "⚠️  Warning: skills directory not found in ~/.claude"
fi

echo "✅ Backup complete!"
echo ""
echo "Next steps:"
echo "  git status              # Review changes"
echo "  git add config/         # Stage changes"
echo "  git commit -m 'Update config'  # Commit changes"
echo "  git push                # Push to remote"
