#!/bin/bash
# Runs on every UserPromptSubmit. Shows a macOS notification if 45+ min since last reminder.

TIMESTAMP_FILE="$HOME/.claude/skills/stretch-break/.last-reminded"
INTERVAL=2700  # 45 minutes in seconds

if [ -f "$TIMESTAMP_FILE" ]; then
  LAST=$(cat "$TIMESTAMP_FILE")
  NOW=$(date +%s)
  if [ $((NOW - LAST)) -lt $INTERVAL ]; then
    exit 0
  fi
fi

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

osascript -e "display notification \"$INSTRUCTIONS $BENEFIT\" with title \"🏃 Stretch break!\" subtitle \"$NAME\""

date +%s > "$TIMESTAMP_FILE"
