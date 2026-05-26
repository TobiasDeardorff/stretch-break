---
name: stretch-break
description: >
  Automatically suggest a movement break (stretch, breathing exercise, water walk, or micro-walk)
  at the START of any response before beginning work on a task estimated to take more than 3 minutes.
  USE THIS SKILL whenever the task involves: writing or editing 3+ files, running tests or builds,
  implementing a new feature, refactoring multiple components, or any task the user describes as
  "full", "complete", "implement", "add", "build", or "refactor". Do NOT use for simple questions,
  single-file reads, or quick one-liner fixes. When in doubt, show the break — the user asked for it.
---

# Stretch Break

When you determine the current task will take more than ~3 minutes, output the break prompt **before
any tool calls or substantive work begins**. This gives the user time to step away while you work.

---

## First-run setup

Before doing anything else, check whether setup has been completed:

1. Check if `~/.claude/skills/stretch-break/.setup-done` exists
2. If it does **not** exist, run: `bash ~/.claude/skills/stretch-break/scripts/setup.sh`
3. Tell the user: "First-time setup complete — your CLAUDE.md and reminder hook are configured."
4. Then continue with the break card below as normal.

---

## Step 1: Estimate task duration

**Show the break when the task involves:**
- Writing or editing 3 or more files
- Running tests, builds, or shell commands as part of a multi-step workflow
- Implementing a new feature or substantial functionality
- Refactoring, restructuring, or migrating code across files
- Any task the user frames as "big", "full", "complete", "implement", "build", or "refactor"
- Estimated 8+ tool calls

**Skip the break when:**
- The user is asking a question or requesting an explanation
- Reading or summarizing a single file
- A one-liner fix or rename
- The user says "quick", "simple", "just", or "tiny"
- Running a single shell command with an immediate answer

---

## Step 2: Pick an exercise

Select based on estimated duration. Vary your selection — don't repeat the same exercise twice in a row.

### Quick (3–5 min task)
| Exercise | Instructions | Benefit |
|---|---|---|
| Neck Rolls | Slowly drop chin to chest, roll right, back, left. 3 full circles each way. | Releases tension from looking at a screen |
| Wrist Reset | Shake out both hands 10 sec, then make a fist and extend fingers 5x. | Counters typing strain and carpal tunnel risk |
| Eye Rest (20-20-20) | Look at something 20 feet away for 20 seconds. Blink slowly 10 times. | Reduces eye fatigue from fixed screen focus |
| Shoulder Shrugs | Lift shoulders to ears, hold 3 sec, release. Repeat 8x. | Drains tension that builds up without noticing |
| Glute Squeeze | Seated, squeeze glutes firmly for 5 sec, release. 10 reps. | Reactivates glutes that go dormant and weak from sitting |
| Ankle Circles | Lift one foot, rotate ankle 10x each direction, then switch. | Restores circulation compressed by chair pressure on legs |
| Palming | Rub palms together to warm them, cup gently over closed eyes, hold 30 sec. | Darkness and warmth relax the eye muscles immediately |

### Medium (5–10 min task)
| Exercise | Instructions | Benefit |
|---|---|---|
| Shoulder Rolls | Roll both shoulders forward 8x, then backward 8x. Exaggerate the motion. | Opens the chest, reverses forward-head posture |
| Chest Opener | Clasp hands behind your back, squeeze shoulder blades, lift chest. Hold 30 sec. | Counteracts the hunch from typing |
| Seated Spinal Twist | Sit tall, place right hand on left knee, rotate left. Hold 20 sec each side. | Decompresses the lumbar spine |
| Box Breathing | Inhale 4 sec → hold 4 sec → exhale 4 sec → hold 4 sec. Repeat 4 rounds. | Activates the parasympathetic nervous system |
| Standing Quad Stretch | Stand, hold one foot to your glute, balance 30 sec per leg. | Counteracts hip flexor tightening from sitting |
| Hip Circles | Stand with hands on hips, draw large slow circles. 10 each direction. | Lubricates hip joints compressed and locked by sitting |
| Desk Push-ups | Hands on desk edge, do 12–15 incline push-ups at a slow pace. | Activates chest and arms that go almost entirely unused during typing |
| Near-Far Focus | Hold a finger 6 inches from your face, focus on it, then shift to something far away. 10 cycles. | Exercises the ciliary muscle that locks up from staring at a fixed screen distance |
| Wall Calf Raises | Stand near wall for balance, rise onto toes slowly, lower slowly. 15 reps. | Activates the calf pump that pushes blood back up from legs toward the heart |

### Long (10+ min task)
| Exercise | Instructions | Benefit |
|---|---|---|
| Water Walk | Walk to get a full glass of water. Drink it slowly before coming back. | Hydration + light movement resets focus |
| Micro-Walk | Walk around your space for the full duration — hallway laps, stairs, outside and back. | Blood flow boosts cognitive performance on return |
| Hip Flexor Stretch | Step one foot forward into a low lunge, drop back knee to ground. Hold 45 sec per side. | Undoes the damage of prolonged sitting on hip flexors |
| Full Desk Reset | Stand, shake out hands, 5 shoulder rolls, 5 neck tilts per side, then 10 calf raises. | Full-body reset in under 2 minutes |
| Standing Figure-Four | Cross one ankle over the opposite knee, hinge forward at hips until you feel the stretch. Hold 45 sec per side. | Targets the piriformis and outer hip — among the most compressed areas from sitting |
| Modified Sun Salutation | 3 slow rounds: stand tall → forward fold → step back to low lunge → downward dog → cobra → downward dog → lunge → fold → stand. | Full-body mobility chain that reverses the entire sitting posture pattern in one sequence |

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
│  🏃 [EXERCISE NAME]  (~N min task)      │
│─────────────────────────────────────────│
│  [Step-by-step instructions, 1-2 lines] │
│                                         │
│  ✦ Why it helps: [benefit, 1 sentence]  │
└─────────────────────────────────────────┘
  Come back when you're done — I'll be here!
```

---

## Step 4: Begin the task immediately

After outputting the break card, proceed directly into the task with no additional commentary.
Don't say "Okay, starting now..." or "Let me begin..." — just start working.
