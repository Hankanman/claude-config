# Claude Config Sync

Cross-platform synchronization system for Claude CLI configuration files.

## What Gets Synced

✅ **Included (safe to version control):**
- `settings.json` - Preferences, permissions, enabled plugins
- `hooks/` - Custom hook scripts
- `skills/` - User-created skills

❌ **Excluded (sensitive/generated):**
- `.credentials.json` - API keys and tokens
- `history.jsonl` - Chat history
- `cache/`, `debug/`, `plugins/` - Runtime data
- And many other runtime/sensitive directories

## Usage

### First-Time Setup

Clone this repository and run the restore script:

```bash
# Linux/Mac
./scripts/restore.sh

# Windows
.\scripts\restore.ps1
```

### Backup Current Config to Repo

```bash
# Linux/Mac
./scripts/backup.sh

# Windows
.\scripts\backup.ps1
```

### Restore Config from Repo

```bash
# Linux/Mac
./scripts/restore.sh

# Windows
.\scripts\restore.ps1
```

## Platform Support

- ✅ Linux (Bash)
- ✅ macOS (Bash)
- ✅ Windows (PowerShell)

## Security

This repository is designed to **exclude all sensitive data**. Review `.gitignore` before committing. Never commit:
- API keys or credentials
- Personal chat history
- User-specific data

## Directory Structure

```
claude-config/
├── config/
│   ├── settings.json
│   ├── hooks/
│   └── skills/
├── scripts/
│   ├── backup.sh
│   ├── restore.sh
│   └── restore.ps1
├── .gitignore
└── README.md
```
