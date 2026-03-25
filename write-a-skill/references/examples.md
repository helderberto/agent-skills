# Skill Examples

## Minimal skill (no references needed)

`grill-me/SKILL.md` — pure instructions, no structure needed, fits in ~20 lines.

```md
---
name: grill-me
description: Interview the user relentlessly about a plan. Use when user says "grill me".
allowed-tools: Read Glob Grep
---

[instructions...]
```

## Skill with pre-loaded context

`atomic-commits/SKILL.md` uses `!` prefix to auto-run commands on load:

```md
## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
```

This avoids the agent spending a turn fetching context it always needs.

## Skill with references

`tdd/SKILL.md` links to `references/principles.md` and `references/examples.md` for content that would bloat the main file:

```md
See [principles.md](references/principles.md) for testing philosophy and anti-patterns.
```

Keep the main file workflow-focused; push reference material to `references/`.

## Anti-patterns to avoid

- Skill that exceeds 50 lines without references offload
- Description that doesn't include triggers: `"Helps with testing."` ← useless
- Hardcoded versions or dates that will become stale
- No error handling section for skills that run Bash commands
