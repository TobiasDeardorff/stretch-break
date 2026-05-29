# stretch-break

A [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) skill that
nudges you to get up and move during long working sessions. When a break is due,
it fires a desktop notification *and* has Claude show a small "break card" in chat
before it starts working — so you can step away while it does the task.

## How it works

The decision of **when** to break and **which** exercise to show is made entirely
by a `UserPromptSubmit` hook (`scripts/remind.sh`) that runs on every prompt.
Claude's only job is to render the card when the hook tells it to.

The hook fires a break only when **two gates** both pass:

1. **Time** — at least `INTERVAL` seconds have passed since the last break
   (default 30 minutes).
2. **Task complexity** — your prompt looks substantial (matches keywords like
   `implement`, `refactor`, `build`, `migrate`, `feature`) rather than trivial
   (`quick`, `simple`, `just`, `explain`, a one-line fix).

When both pass, the hook fires a desktop notification and injects a
`[stretch-break]` signal into Claude's context naming the chosen exercise. A
`## Movement Breaks` instruction in your `~/.claude/CLAUDE.md` tells Claude to
render the card for that exercise before any tool calls, then begin work.

### Carry-over

If the interval has elapsed but your current task is *trivial*, the hook stays
silent and **does not reset its timer**. The break carries over to the next
substantial task instead of being spent on a one-liner. Breaks stay paced to your
real work, not to the clock alone.

### The break card

```
⬛🟧🟧🟧🟧⬛
⬜⬜⬜⬜⬜⬜
🟧⬛🟧🟧⬛🟧   Claude's on it!
🟧🟧🟧🟧🟧🟧   Go do this while I work:
⬛🟧⬛⬛🟧⬛
┌─────────────────────────────────────────┐
│  🏃 Box Breathing                        │
│─────────────────────────────────────────│
│  Inhale 4s, hold 4s, exhale 4s, hold 4s.│
│                                         │
│  ✦ Why it helps: lowers cortisol        │
└─────────────────────────────────────────┘
  Come back when you're done — I'll be here!
```

## Install

**Install once, globally — it applies to every project.** Everything lives under
`~/.claude/` (your user-level Claude Code home), so you do *not* add this to
individual repos and there's nothing to repeat per project.

```bash
# 1. Clone this skill into Claude Code's global skills directory
git clone <your-repo-url> ~/.claude/skills/stretch-break

# 2. Run the installer (edits your global ~/.claude config)
bash ~/.claude/skills/stretch-break/scripts/setup.sh
```

Then **restart your Claude Code session** so the updated `settings.json` loads.
That's it — breaks now trigger in every project on this machine.

> **Two different locations, don't confuse them:** `<your-repo-url>` is *this
> skill's own Git repo* (where you push changes). `~/.claude/skills/stretch-break`
> is Claude Code's global skills folder — **not** one of your code projects.
> Installing just places a copy of the skill where Claude Code looks for it
> globally; it has nothing to do with whatever repo you happen to be working in.

`setup.sh` is idempotent — safe to run again any time to repair or upgrade your
config. It never duplicates the hook or the CLAUDE.md block.

## What setup changes on your system

`setup.sh` makes exactly two edits and creates one marker — all in your
**global** `~/.claude/` directory, none of it inside any project:

- Appends a `## Movement Breaks` section to `~/.claude/CLAUDE.md`.
- Registers a `UserPromptSubmit` hook in `~/.claude/settings.json` pointing at
  `scripts/remind.sh`.
- Touches `~/.claude/skills/stretch-break/.setup-done` (first-run marker).

Both edits converge to a fixed known state, so re-running repairs config rather
than stacking duplicates. Unrelated hooks and CLAUDE.md sections are left untouched.

## Configuration

All tuning lives at the top of `scripts/remind.sh`:

```bash
INTERVAL=1800   # seconds between breaks. 1800 = 30 min, 1500 = 25 min, 2700 = 45 min.

SUBSTANTIAL='implement|refactor|\bbuild\b|migrat|...'   # prompts that earn a break
TRIVIAL='\bquick\b|\bsimple\b|\bjust\b|...'             # prompts that don't (wins ties)
```

Edit the keyword lists to fit how you phrase tasks. `TRIVIAL` always overrides
`SUBSTANTIAL`.

## Uninstall

```bash
bash ~/.claude/skills/stretch-break/scripts/uninstall.sh
```

This surgically removes only stretch-break's own additions — the `## Movement
Breaks` block and the `UserPromptSubmit` hook — and clears the runtime markers.
Your other hooks and CLAUDE.md content are preserved. It leaves the skill files
in place and prints the command to delete those too if you want a full removal.
Restart your session afterward.

## Limitations & caveats

- **Context injection is Claude Code version-sensitive.** The desktop
  notification fires reliably, but whether Claude actually *sees* the
  `[stretch-break]` signal and shows the card depends on your version honoring
  `additionalContext` output from `UserPromptSubmit` hooks. Smoke-test after
  install: work past the interval on a substantial task and confirm a card
  appears. If only the notification fires, your version isn't injecting the
  context.
- **Complexity screening is keyword-based, not semantic.** A substantial task
  phrased without a recognized keyword (e.g. "ok, go ahead and do it") is
  screened out and carries over to the next explicitly-worded task. Widen the
  `SUBSTANTIAL` list if you hit this often.
- **Notifications are macOS / Linux only.** macOS uses `osascript`, Linux uses
  `notify-send` (if installed). Other platforms skip the notification silently;
  the in-chat card still works.

## Repo layout

```
.
├── SKILL.md              # how Claude renders the card on a [stretch-break] signal
├── scripts/
│   ├── setup.sh          # idempotent installer (CLAUDE.md block + hook)
│   ├── remind.sh         # the UserPromptSubmit hook: timing + complexity + signal
│   └── uninstall.sh      # surgical reversal of setup
└── .gitignore            # ignores runtime state (.setup-done, .last-reminded)
```
