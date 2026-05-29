#!/bin/bash
# Reverses setup.sh. Surgical and idempotent: removes ONLY the stretch-break
# additions (the CLAUDE.md "## Movement Breaks" section and the settings.json
# UserPromptSubmit hook), clears runtime markers, and leaves everything else in
# your config untouched. Safe to run even if nothing is installed.
# The skill files are left in place; this prints how to delete them if you want.

SKILL_DIR="$HOME/.claude/skills/stretch-break"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SETTINGS_JSON="$HOME/.claude/settings.json"

PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null)
if [ -z "$PYTHON" ]; then
  echo "Error: Python 3 is required for uninstall but was not found." >&2
  exit 1
fi

echo "Uninstalling stretch-break..."

# --- 1. CLAUDE.md: remove the Movement Breaks section, keep the rest ---
if [ -f "$CLAUDE_MD" ]; then
  "$PYTHON" - "$CLAUDE_MD" << 'PYEOF'
import os, re, sys
path = sys.argv[1]
with open(path) as f:
    text = f.read()

lines, out, i, had = text.split("\n"), [], 0, False
while i < len(lines):
    if lines[i].strip() == "## Movement Breaks":
        had = True
        i += 1
        while i < len(lines) and not re.match(r'^#{1,2} ', lines[i]):
            i += 1
        continue
    out.append(lines[i]); i += 1

body = re.sub(r'\n{3,}', '\n\n', "\n".join(out)).rstrip("\n")
with open(path, "w") as f:
    f.write(body + "\n" if body.strip() else "")
print("Removed CLAUDE.md block" if had else "No CLAUDE.md block found (skipped)")
PYEOF
else
  echo "No CLAUDE.md found (skipped)"
fi

# --- 2. settings.json: remove only the stretch-break hook, clean up empties ---
if [ -f "$SETTINGS_JSON" ]; then
  "$PYTHON" - "$SETTINGS_JSON" << 'PYEOF'
import json, os, sys
path = sys.argv[1]
with open(path) as f:
    try:
        settings = json.load(f)
    except Exception:
        settings = {}

hooks = settings.get("hooks", {})
removed, kept = False, []
for group in hooks.get("UserPromptSubmit", []):
    orig = group.get("hooks", [])
    inner = [h for h in orig if "stretch-break" not in h.get("command", "")]
    if len(inner) != len(orig):
        removed = True
    if inner:
        group["hooks"] = inner
        kept.append(group)

if kept:
    hooks["UserPromptSubmit"] = kept
else:
    hooks.pop("UserPromptSubmit", None)
if not hooks:
    settings.pop("hooks", None)

with open(path, "w") as f:
    json.dump(settings, f, indent=2)
print("Removed hook from settings.json" if removed else "No stretch-break hook found (skipped)")
PYEOF
else
  echo "No settings.json found (skipped)"
fi

# --- 3. runtime markers ---
rm -f "$SKILL_DIR/.setup-done" "$SKILL_DIR/.last-reminded"
echo "Cleared runtime markers"

echo
echo "stretch-break uninstalled — config reverted."
echo "Skill files remain at: $SKILL_DIR"
echo "To remove those too:   rm -rf \"$SKILL_DIR\""
echo "Restart your Claude Code session so settings.json reloads."
