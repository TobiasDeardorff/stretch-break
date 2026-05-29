#!/bin/bash
# Runs on every UserPromptSubmit. Owns BOTH the timing and the complexity
# screening of breaks (Architecture A).
#
# Fires a break (desktop notification + [stretch-break] context signal) only when:
#   (1) at least INTERVAL seconds have passed since the last break, AND
#   (2) the current prompt looks like a substantial task.
#
# If the interval has elapsed but the task looks trivial, it exits WITHOUT
# resetting the timer — so the break "carries over" to the next substantial
# task instead of being wasted. Between intervals it is completely silent.

# --- tunables ---------------------------------------------------------------
INTERVAL=1800            # seconds between breaks. 1800=30m, 1500=25m, 2700=45m.

# Keyword screen (the tuning surface — edit freely). Trivial overrides substantial.
SUBSTANTIAL='implement|refactor|\bbuild\b|migrat|rewrite|scaffold|feature|\bfull\b|complete|\badd\b|\bcreate\b|across|multiple files|set up|integrat|\bport\b'
TRIVIAL='\bquick\b|\bsimple\b|\bjust\b|\btiny\b|typo|rename|one-?liner|what is|whats|how do|\bexplain\b|^read '
# ----------------------------------------------------------------------------

TIMESTAMP_FILE="$HOME/.claude/skills/stretch-break/.last-reminded"

# --- read the prompt Claude Code passes in on stdin (JSON) ---
INPUT=$(cat)
PROMPT=""
if command -v python3 >/dev/null 2>&1; then
  PROMPT=$(printf '%s' "$INPUT" | python3 -c "import sys,json;print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null)
fi

# --- complexity screen ---
# Default to "substantial" only when we genuinely couldn't read the prompt, so a
# parse/python failure degrades gracefully to pure time-cadence rather than going
# silent forever. With a real prompt, default to trivial unless a keyword hits.
if [ -z "$PROMPT" ]; then
  looks_substantial=true
else
  looks_substantial=false
  printf '%s' "$PROMPT" | grep -qiE "$SUBSTANTIAL" && looks_substantial=true
  printf '%s' "$PROMPT" | grep -qiE "$TRIVIAL"     && looks_substantial=false   # trivial wins
fi

# --- time screen: bail silently if the interval hasn't elapsed ---
if [ -f "$TIMESTAMP_FILE" ]; then
  LAST=$(cat "$TIMESTAMP_FILE" 2>/dev/null || echo 0)
  NOW=$(date +%s)
  if [ $((NOW - LAST)) -lt "$INTERVAL" ]; then
    exit 0
  fi
fi

# --- interval HAS elapsed. If the task is trivial, carry over (no fire, no reset) ---
if [ "$looks_substantial" != "true" ]; then
  exit 0
fi

# --- both gates passed: pick an exercise ---
EXERCISES=(
  "Neck Rolls|Roll your head slowly in a full circle, 3x each way.|Releases screen tension"
  "Wrist Reset|Shake out both hands 10 sec, then fist-and-extend 5x.|Counters typing strain"
  "Eye Rest (20-20-20)|Look 20 feet away for 20 seconds, blink slowly 10x.|Reduces eye fatigue"
  "Shoulder Shrugs|Lift shoulders to ears, hold 3 sec, release. 8x.|Drains built-up tension"
  "Shoulder Rolls|Roll both shoulders forward 8x, then back 8x.|Opens chest, fixes posture"
  "Chest Opener|Clasp hands behind back, squeeze blades, hold 30 sec.|Counters the typing hunch"
  "Box Breathing|Inhale 4s, hold 4s, exhale 4s, hold 4s. 4 rounds.|Lowers cortisol"
  "Seated Spinal Twist|Right hand on left knee, rotate left. Hold 20 sec each side.|Decompresses spine"
  "Water Walk|Walk to get a full glass of water and drink it slowly.|Hydration + movement reset"
  "Micro-Walk|Walk around your space for 2 to 3 minutes.|Blood flow boosts focus"
  "Hip Flexor Stretch|Low lunge, back knee down, hold 45 sec per side.|Undoes sitting damage"
  "Standing Quad Stretch|Hold one foot to glute, balance 30 sec per leg.|Counteracts hip tightening"
  "Full Desk Reset|Shake hands, 5 shoulder rolls, 5 neck tilts, 10 calf raises.|Full-body reset"
)
IDX=$((RANDOM % ${#EXERCISES[@]}))
IFS='|' read -r NAME INSTRUCTIONS BENEFIT <<< "${EXERCISES[$IDX]}"

# --- desktop notification (best-effort, cross-platform) ---
case "$(uname -s)" in
  Darwin) osascript -e "display notification \"$INSTRUCTIONS $BENEFIT\" with title \"🏃 Stretch break!\" subtitle \"$NAME\"" 2>/dev/null ;;
  Linux)  command -v notify-send >/dev/null 2>&1 && notify-send "🏃 Stretch break! — $NAME" "$INSTRUCTIONS  ($BENEFIT)" ;;
esac

# --- reset the timer (only happens on a real fire) ---
date +%s > "$TIMESTAMP_FILE"

# --- emit the context signal for Claude (structured JSON, parsed on exit 0) ---
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[stretch-break] Movement break due (~%s min since the last one). Show the stretch-break card for: %s — %s (%s) BEFORE any tool calls, then begin work immediately. The hook already decided a break is warranted; do not second-guess it."}}\n' \
  "$((INTERVAL / 60))" "$NAME" "$INSTRUCTIONS" "$BENEFIT"

exit 0
