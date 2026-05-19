---
name: write-a-skill
description: Create new agent skills with proper structure and progressive disclosure. Use when user wants to create, write, or build a new skill, or asks "make a skill for X".
---

# Write a Skill

## Process

1. **Clarify scope** -- ask the user (use AskUserQuestion when available; otherwise present as numbered options):
   - "What type of skill?" — Options: "Pure instructions (no scripts)", "Instructions + helper scripts", "Wrapper around CLI tool"
   - "Does it need pre-loaded context?" — Options: "Yes — auto-run commands on load (Recommended)", "No — gather context during workflow"
2. **Explore existing skills** -- `ls` the skills repo, read similar skills for conventions
3. **Draft** -- create `SKILL.md`
4. **Review with user** -- confirm coverage, ask what's missing

## Structure

```
skill-name/
├── SKILL.md              # Required. Metadata + instructions.
├── references/           # Optional. Long-form docs the agent reads on demand.
└── scripts/              # Optional. Executable helpers (.sh, .py) called via Bash.
    └── scan-secrets.sh
```

Keep instructions in `SKILL.md`. Split material longer than ~150 lines into `references/` and link from `SKILL.md` rather than inlining — preserves progressive disclosure.

## SKILL.md Template

```md
---
name: skill-name
description: One sentence what it does. Use when [triggers]. Don't use when [anti-triggers].
---

# Skill Name

## Workflow
[numbered steps]

## Rules
[hard constraints]

## Error Handling
[if X -- do Y]
```

## Frontmatter Fields

| Field | Required | Notes |
|---|---|---|
| `name` | yes | kebab-case, matches directory |
| `description` | yes | Agent's only signal for when to load this skill |
| `argument-hint` | no | One-line hint shown next to the skill name (e.g. `'[slug]'`, `'<idea>'`) |

Avoid `compatibility:` and `allowed-tools:` — legacy `npx skills` CLI fields, not part of the Claude Code plugin spec.

## Description Rules

The description is the **only thing the agent sees** when choosing which skill to load.

- Max 1024 chars
- First sentence: what it does
- Second sentence: `Use when [triggers]`
- Third sentence (optional): `Don't use when [anti-triggers]`

**Good:** `Groups unstaged changes into atomic commits by concern. Use when user says "atomic commits" or wants to split changes before pushing.`
**Bad:** `Helps with commits.`

## Examples

**Minimal skill** -- pure instructions, fits in ~20 lines:
```md
---
name: grill-me
description: Interview the user relentlessly about a plan. Use when user says "grill me".
---

[instructions...]
```

**Pre-loaded context** -- `!` prefix auto-runs commands on load:
```md
## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
```

Avoids wasting a turn fetching context the agent always needs.

## Rules

- No time-sensitive info (versions, dates) in skills
- Include error handling for foreseeable failure modes
- Test the skill by invoking it before shipping

## Anti-patterns

- Description without triggers: `"Helps with testing."` -- useless
- Hardcoded versions or dates that go stale
- No error handling for skills that run Bash commands
