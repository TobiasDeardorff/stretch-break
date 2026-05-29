#!/bin/bash
# Setup for the stretch-break skill. Safe to re-run: idempotent and convergent.
# Every run lands on the same correct config — it never duplicates the CLAUDE.md
# block or the settings.json hook, and it repairs/upgrades a stale block or a
# moved hook path. Run it again any time to heal the configuration.

SKILL_DIR="$HOME/.claude/skills/stretch-break"
SETUP_DONE="$SKILL_DIR/.setup-done"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
SETTINGS_JSON="$HOME/.claude/settings.json"
REMIND_SCRIPT="$SKILL_DIR/scripts/remind.sh"

mkdir -p "$SKILL_DIR" "$(dirname "$CLAUDE_MD")"
echo "Setting up stretch-break (safe to re-run)..."

# Canonical CLAUDE.md block — the single source of truth for the instruction.
read -r -d '' BLOCK << 'MDEOF'
## Movement Breaks
A UserPromptSubmit hook tracks elapsed time AND screens the task. It injects a
line starting with "[stretch-break]" only when enough time has passed since the
last break and the current task looks substantial enough to warrant one.

- When you see a "[stretch-break]" signal, output the stretch-break card BEFORE
  any tool calls, then begin work immediately with no extra commentary. The hook
  has already decided a break is warranted — don't second-guess it or re-judge
  the task. Use the exercise named in the signal.
- When there is no "[stretch-break]" signal, do not show a card, even on a long
  task. The hook owns both the timing and the screening so breaks stay paced.
MDEOF

# Locate Python (handles asdf, homebrew, system).
PYTHON=$(command -v python3 2>/dev/null \
  || command -v python 2>/dev/null \
  || echo "$HOME/.asdf/installs/python/3.12.8/bin/python3")
if [ ! -x "$PYTHON" ]; then
  echo "Error: Python 3 is required for setup but was not found." >&2
  exit 1
fi

# --- 1. CLAUDE.md: strip any existing Movement Breaks section, then append the
#        canonical one. Convergent — old/stale blocks are replaced, not stacked.
BLOCK="$BLOCK" "$PYTHON" - "$CLAUDE_MD" << 'PYEOF'
import os, re, sys
path  = sys.argv[1]
block = os.environ.get("BLOCK", "").rstrip("\n")

text = ""
if os.path.exists(path):
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
new  = (body + "\n\n" + block + "\n") if body.strip() else (block + "\n")
with open(path, "w") as f:
    f.write(new)
print("Updated CLAUDE.md block (replaced existing)" if had else "Added CLAUDE.md block")
PYEOF

# --- 2. settings.json: remove any prior stretch-break UserPromptSubmit hook,
#        then add the current one. Convergent — fixes a moved path, no dupes.
"$PYTHON" - "$SETTINGS_JSON" "$REMIND_SCRIPT" << 'PYEOF'
import json, os, sys
path, cmd = sys.argv[1], sys.argv[2]

settings = {}
if os.path.exists(path):
    with open(path) as f:
        try:
            settings = json.load(f)
        except Exception:
            settings = {}

hooks = settings.setdefault("hooks", {})
kept = []
for group in hooks.get("UserPromptSubmit", []):
    inner = [h for h in group.get("hooks", []) if "stretch-break" not in h.get("command", "")]
    if inner:
        group["hooks"] = inner
        kept.append(group)
kept.append({"matcher": "", "hooks": [{"type": "command", "command": cmd}]})
hooks["UserPromptSubmit"] = kept

with open(path, "w") as f:
    json.dump(settings, f, indent=2)
print("Registered reminder hook in settings.json")
PYEOF

# --- 3. perms + first-run marker ---
chmod +x "$REMIND_SCRIPT" 2>/dev/null
touch "$SETUP_DONE"
echo "stretch-break setup complete! (Restart your session to load settings.json.)"
