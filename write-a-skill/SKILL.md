---
name: write-a-skill
description: Create new agent skills with proper structure, frontmatter, and progressive disclosure. Use when user wants to create, write, or build a new skill, or asks "make a skill for X".
allowed-tools: Read Glob Grep Write Bash
---

# Write a Skill

## Process

1. **Clarify scope** — ask what task/domain, what triggers it, whether it needs scripts or just instructions
2. **Explore existing skills** — `ls` the skills repo, read similar skills for conventions
3. **Draft** — create `SKILL.md` + supporting files
4. **Review with user** — confirm coverage, ask what's missing

## Structure

```
skill-name/
├── SKILL.md              # Required. Keep under 50 lines.
└── references/           # Optional. One file per domain/concern.
    ├── examples.md
    └── patterns.md
```

Use `references/` for content that exceeds SKILL.md's budget or is rarely needed.

## SKILL.md Template

```md
---
name: skill-name
description: One sentence what it does. Use when [specific triggers]. Don't use when [anti-triggers].
compatibility: Requires X        # optional
allowed-tools: Bash Read Write   # space-separated
---

# Skill Name

## Workflow
[numbered steps]

## Rules
[hard constraints]

## Error Handling
[if X → do Y]
```

## Frontmatter Fields

| Field | Required | Notes |
|---|---|---|
| `name` | yes | kebab-case, matches directory |
| `description` | yes | agent's only signal for when to load this skill |
| `allowed-tools` | yes | space-separated Claude Code tool names |
| `compatibility` | no | env/runtime prerequisites |
| `disable-model-invocation` | no | set `true` to skip LLM, run scripts only |

## Description Rules

The description is the **only thing the agent sees** when choosing which skill to load.

- Max 1024 chars
- First sentence: what it does
- Second sentence: `Use when [triggers]`
- Third sentence (optional): `Don't use when [anti-triggers]`

**Good:** `Groups unstaged changes into atomic commits by concern. Use when user says "atomic commits" or wants to split changes before pushing.`
**Bad:** `Helps with commits.`

See [references/examples.md](references/examples.md) for annotated real skills.

## Rules

- SKILL.md must stay under 50 lines of content
- No time-sensitive info (versions, dates) in skills
- Add `references/` files only when SKILL.md would exceed budget
- Include error handling for foreseeable failure modes
- Test the skill by invoking it before shipping
