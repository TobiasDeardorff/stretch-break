---
name: stretch-break
description: >
  Render a movement-break card when the stretch-break hook has injected a
  "[stretch-break]" signal into the conversation context. USE THIS SKILL when you
  see a line beginning with "[stretch-break]" — it means the UserPromptSubmit hook
  has already determined, from elapsed time and task complexity, that a break is
  due, and has named the exercise to show. Do NOT decide on your own whether to
  show a break and do NOT pick your own exercise; the hook owns both decisions.
  When you see no signal, do not show a card, even on a long task.
---

# Stretch Break

This skill renders a movement-break card. The decision of *when* to break and
*which* exercise to show is made by the `remind.sh` UserPromptSubmit hook, which
injects a `[stretch-break]` signal into context when a break is due. Your job is
to render that signal as a card — nothing more.

---

## First-run setup

Before doing anything else, check whether setup has been completed:

1. Check if `~/.claude/skills/stretch-break/.setup-done` exists
2. If it does **not** exist, run: `bash ~/.claude/skills/stretch-break/scripts/setup.sh`
3. Tell the user: "First-time setup complete — your CLAUDE.md and reminder hook are configured."

---

## Step 1: Confirm there is a signal

Only proceed if the current context contains a line beginning with
`[stretch-break]`. If there is no such signal, **do not show a card** — the hook
has decided a break is not yet due. Never trigger a break on your own estimate of
task duration; that is the hook's job, and second-guessing it breaks the pacing
and the carry-over behavior.

---

## Step 2: Use the exercise from the signal

The `[stretch-break]` signal names the exercise to show, in the form
`NAME — INSTRUCTIONS (BENEFIT)`. Use exactly that exercise so the card matches the
desktop notification the hook already fired. Do not substitute your own.

The full catalog below is reference only (and a fallback if a signal ever arrives
without a named exercise).

### Quick (3–5 min)
| Exercise | Instructions | Benefit |
|---|---|---|
| Neck Rolls | Slowly drop chin to chest, roll right, back, left. 3 full circles each way. | Releases tension from looking at a screen |
| Wrist Reset | Shake out both hands 10 sec, then make a fist and extend fingers 5x. | Counters typing strain and carpal tunnel risk |
| Eye Rest (20-20-20) | Look at something 20 feet away for 20 seconds. Blink slowly 10 times. | Reduces eye fatigue from fixed screen focus |
| Shoulder Shrugs | Lift shoulders to ears, hold 3 sec, release. Repeat 8x. | Drains tension that builds up without noticing |
| Glute Squeeze | Seated, squeeze glutes firmly for 5 sec, release. 10 reps. | Reactivates glutes that go dormant from sitting |
| Ankle Circles | Lift one foot, rotate ankle 10x each direction, then switch. | Restores circulation compressed by chair pressure |
| Palming | Rub palms together to warm them, cup gently over closed eyes, hold 30 sec. | Darkness and warmth relax the eye muscles |

### Medium (5–10 min)
| Exercise | Instructions | Benefit |
|---|---|---|
| Shoulder Rolls | Roll both shoulders forward 8x, then backward 8x. Exaggerate the motion. | Opens the chest, reverses forward-head posture |
| Chest Opener | Clasp hands behind your back, squeeze shoulder blades, lift chest. Hold 30 sec. | Counteracts the hunch from typing |
| Seated Spinal Twist | Sit tall, place right hand on left knee, rotate left. Hold 20 sec each side. | Decompresses the lumbar spine |
| Box Breathing | Inhale 4 sec → hold 4 sec → exhale 4 sec → hold 4 sec. Repeat 4 rounds. | Activates the parasympathetic nervous system |
| Standing Quad Stretch | Stand, hold one foot to your glute, balance 30 sec per leg. | Counteracts hip flexor tightening from sitting |
| Hip Circles | Stand with hands on hips, draw large slow circles. 10 each direction. | Lubricates hip joints locked by sitting |
| Desk Push-ups | Hands on desk edge, do 12–15 incline push-ups at a slow pace. | Activates chest and arms unused during typing |
| Near-Far Focus | Hold a finger 6 inches away, focus on it, then shift to something far. 10 cycles. | Exercises the ciliary muscle that locks up from fixed focus |
| Wall Calf Raises | Stand near wall for balance, rise onto toes slowly, lower slowly. 15 reps. | Activates the calf pump that returns blood from the legs |

### Long (10+ min)
| Exercise | Instructions | Benefit |
|---|---|---|
| Water Walk | Walk to get a full glass of water. Drink it slowly before coming back. | Hydration + light movement resets focus |
| Micro-Walk | Walk around your space — hallway laps, stairs, outside and back. | Blood flow boosts cognitive performance on return |
| Hip Flexor Stretch | Step one foot forward into a low lunge, drop back knee to ground. Hold 45 sec per side. | Undoes prolonged sitting on hip flexors |
| Full Desk Reset | Stand, shake out hands, 5 shoulder rolls, 5 neck tilts per side, then 10 calf raises. | Full-body reset in under 2 minutes |
| Standing Figure-Four | Cross one ankle over the opposite knee, hinge forward at hips until you feel the stretch. Hold 45 sec per side. | Targets the piriformis and outer hip |
| Modified Sun Salutation | 3 slow rounds: stand → forward fold → low lunge → downward dog → cobra → downward dog → lunge → fold → stand. | Full-body mobility chain that reverses sitting posture |

---

## Step 3: Output the break card

Render as a code block so the pixel art and box align correctly.

```
⬛🟧🟧🟧🟧⬛
⬜⬜⬜⬜⬜⬜
🟧⬛🟧🟧⬛🟧   Claude's on it!
🟧🟧🟧🟧🟧🟧   Go do this while I work:
⬛🟧⬛⬛🟧⬛
┌─────────────────────────────────────────┐
│  🏃 [EXERCISE NAME]                      │
│─────────────────────────────────────────│
│  [Step-by-step instructions, 1-2 lines] │
│                                         │
│  ✦ Why it helps: [benefit, 1 sentence]  │
└─────────────────────────────────────────┘
  Come back when you're done — I'll be here!
```

---

## Step 4: Begin the task immediately

After outputting the break card, proceed directly into the task with no
additional commentary. Don't say "Okay, starting now..." — just start working.
