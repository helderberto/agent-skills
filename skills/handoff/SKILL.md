---
name: handoff
description: Compact the current conversation into a handoff doc so a fresh agent can continue the work. Use when user asks to "handoff", "/handoff", "hand this off", or wants to end a session mid-task. Don't use for summarising completed work, writing PRDs/plans/ADRs, or committing changes.
argument-hint: "What will the next session be used for?"
---

# Handoff

Write a handoff document summarising the current conversation so a fresh agent can continue.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.

## Workflow

1. **Create the file** — `mktemp /tmp/handoff-XXXXXX.md`. Use the absolute path it returns.
2. **Fill the template** below.
3. **Print the path** at the end so the user can paste it into the next session.

## Template

```md
# Handoff — <one-line goal>

## Goal
What the next session should accomplish. If `$ARGUMENTS` was passed, lead with it.

## State
- Branch: <branch>
- Uncommitted: <yes/no + short summary, or "clean">
- Last action: <what we just finished or were doing>

## Decisions made
Non-obvious choices already settled. Skip anything obvious from the code.

## Open questions
Explicit unknowns the next agent must resolve before progressing.

## Next steps
Concrete first action — a command, a file to open, a test to write.

## References
Paths or URLs to PRDs, plans, ADRs, issues, commits, diffs. Do NOT duplicate their content.

## Suggested skills
List skills the next session should likely invoke (e.g. `/hb:build`, `/hb:tdd`).
```

## Rules

- Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL.
- Keep it under ~80 lines. A handoff doc is a pointer, not a transcript.
- Omit sections that don't apply rather than padding with "N/A".

## Error Handling

- If `mktemp` fails → fall back to `/tmp/handoff-$(date +%s).md` and print the path.
- If no arguments were passed → ask the user one question for the Goal section, then proceed.
