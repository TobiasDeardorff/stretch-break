#!/bin/bash
# One-time setup for stretch-break skill.
# Adds the CLAUDE.md instruction and UserPromptSubmit hook, then marks setup done.

SKILL_DIR="$HOME/.claude/skills/stretch-break"
SETUP_DONE="$SKILL_DIR/.setup-done"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SETTINGS_JSON="$HOME/.claude/settings.json"
REMIND_SCRIPT="$SKILL_DIR/scripts/remind.sh"

[ -f "$SETUP_DONE" ] && exit 0

echo "Setting up stretch-break..."

# --- 1. CLAUDE.md entry ---
if [ ! -f "$CLAUDE_MD" ] || ! grep -q "stretch-break" "$CLAUDE_MD"; then
  cat >> "$CLAUDE_MD" << 'MDEOF'

## Movement Breaks
Before starting any task that involves writing or editing multiple files, implementing a feature,
running tests, or any work likely to take more than 3 minutes — invoke the `stretch-break` skill
to show a movement prompt. Do this before any tool calls.
MDEOF
  echo "Added instruction to ~/.claude/CLAUDE.md"
fi

# --- 2. settings.json hook ---
chmod +x "$REMIND_SCRIPT"

# Find python3 (handles asdf, homebrew, system)
PYTHON=$(command -v python3 2>/dev/null \
  || command -v python 2>/dev/null \
  || echo "$HOME/.asdf/installs/python/3.12.8/bin/python3")

if [ ! -x "$PYTHON" ]; then
  echo "Warning: Python not found, skipping hook setup. Add manually."
else
  "$PYTHON" - "$SETTINGS_JSON" "$REMIND_SCRIPT" << 'PYEOF'
import sys, json, os

settings_path, remind_script = sys.argv[1], sys.argv[2]

settings = {}
if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)

# Skip if hook already present
for h in settings.get("hooks", {}).get("UserPromptSubmit", []):
    for inner in h.get("hooks", []):
        if "stretch-break" in inner.get("command", ""):
            sys.exit(0)

settings.setdefault("hooks", {}).setdefault("UserPromptSubmit", []).append({
    "matcher": "",
    "hooks": [{"type": "command", "command": remind_script}]
})

with open(settings_path, "w") as f:
    json.dump(settings, f, indent=2)

print("Added reminder hook to ~/.claude/settings.json")
PYEOF
fi

# --- 3. Mark done ---
touch "$SETUP_DONE"
echo "stretch-break setup complete!"
