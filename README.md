# stretch-break

A Claude Code skill that suggests movement breaks before long-running tasks — keeping you active while Claude works.

## What it does

- Shows a break card (stretch, breathing exercise, water walk, or micro-walk) **before any task estimated to take 3+ minutes**
- Picks an appropriate exercise based on estimated task duration
- Sends a **macOS notification every 45 minutes** as a background reminder, regardless of task length
- Self-installing — configures your `CLAUDE.md` and hook on first use

## Exercises

22 exercises across three tiers, themed around reversing the effects of sitting:

- **Quick (3–5 min):** Neck Rolls, Wrist Reset, Eye Rest, Shoulder Shrugs, Glute Squeeze, Ankle Circles, Palming
- **Medium (5–10 min):** Shoulder Rolls, Chest Opener, Seated Spinal Twist, Box Breathing, Standing Quad Stretch, Hip Circles, Desk Push-ups, Near-Far Focus, Wall Calf Raises
- **Long (10+ min):** Water Walk, Micro-Walk, Hip Flexor Stretch, Full Desk Reset, Standing Figure-Four, Modified Sun Salutation

## Installation

1. Drag `stretch-break.skill` into Claude Code
2. Start a new session
3. Give Claude any substantial task — the skill will fire automatically and run first-time setup

First-time setup adds:
- A `~/.claude/CLAUDE.md` instruction so the skill triggers reliably
- A `UserPromptSubmit` hook that fires a macOS notification every 45 minutes

## Requirements

- Claude Code
- macOS (for background notifications via `osascript`)
- Python 3 (for first-time setup)
