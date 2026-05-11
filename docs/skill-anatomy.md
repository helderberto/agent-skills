# Skill Anatomy

Every skill in this plugin follows the same shape. This doc is the reference for writing or modifying one.

## Directory layout

```
skills/<skill-name>/
├── SKILL.md              required — entry point
├── references/           optional — deep material loaded on demand
│   └── <topic>.md
└── scripts/              optional — executable helpers the skill invokes
    └── <script>.sh
```

- `<skill-name>` is kebab-case, no spaces, no underscores
- Folder name must match the `name:` field in the frontmatter

## SKILL.md structure

A skill is a Markdown file with YAML frontmatter and a body. Keep it focused — one skill = one job.

### Frontmatter

```yaml
---
name: <skill-name>
description: <what it does>. Use when <triggers>. Don't use for <anti-triggers>.
---
```

| Field | Required | Purpose |
| ----- | -------- | ------- |
| `name` | yes | Skill identifier; must equal the folder name |
| `description` | yes | Drives auto-routing; agent reads this to decide if the skill applies |

**Optional fields** (use sparingly):

| Field | Purpose |
| ----- | ------- |
| `argument-hint` | One-line hint shown alongside the skill name (e.g. `'[slug]'`, `'<idea>'`) |

Avoid `compatibility:` and `allowed-tools:` — those were legacy `npx skills` CLI conventions, not part of the Claude Code plugin spec.

### Description writing

Write three sentences in the description:

1. **What the skill does** — one short clause, starts with a verb in third person.
2. **When to use it** — "Use when..." with concrete triggers (slash command name, phrases the user might say, observable states).
3. **When NOT to use it** — "Don't use for..." with anti-triggers that point to neighboring skills.

Example from `commit`:

> Create git commits following repository style. Use when user asks to "create a commit", "commit changes", "/commit", or requests committing code to git. Don't use for pushing code, creating pull requests, or reviewing changes.

The "Don't use for" line prevents the skill from triggering when a neighbor is the better fit. This matters a lot once you have 40+ skills — overlap kills auto-routing.

### Body sections

The body is free-form, but most skills include these sections in this order:

1. **Brief overview** (1–3 sentences) — restate purpose in context, link to references if any.
2. **When to Use** — expand the description's triggers; only include if the description isn't enough.
3. **Workflow** — numbered or phased steps the skill should follow. Concrete and actionable; no philosophy here.
4. **Rules** — bullet list of must-do / never-do constraints.
5. **Error Handling** — what to do when each likely failure mode occurs.
6. **Verification** — a checklist the agent can run at the end to confirm the work landed.

Skills that orchestrate other skills (`review`, `ship`) replace "Workflow" with explicit phases that announce each sub-skill being invoked.

### Pre-loaded context (optional)

Workflow skills can pre-load shell output at the top of the body:

```markdown
## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
```

The `!` prefix tells Claude Code to execute the command and inject the output as context. Use this for git state, package.json, file listings — anything the skill always needs.

## References subfolder

Skills longer than ~150 lines often split deep material into `references/`. The skill body links to a reference instead of inlining:

```markdown
See [principles.md](references/principles.md) for testing philosophy and mocking guidelines.
```

References load on demand. They keep the main SKILL.md scannable while preserving deep guidance.

## Scripts subfolder

When a skill needs to run a specific shell helper (e.g., secret scanning, lcov parsing), put it in `scripts/` and reference it from the workflow:

```markdown
1. Run `bash scripts/scan-secrets.sh` to scan tracked files for credential patterns
```

Make scripts executable (`chmod +x`) before committing.

## Naming conventions

- Skill names are lowercase kebab-case: `code-review`, `safe-repo`, `visual-validate`
- Workflow skills (PRD, plan, build, etc.) use short verbs or nouns matching their phase
- Toolbelt skills describe the action: `lint`, `coverage`, `deps-audit`
- Avoid version suffixes (`-v2`, `-new`) — evolve the skill in place or deprecate

## Phase placement

Skills are grouped by SDLC phase in the [README](../README.md) table:

| Phase | Question the skill answers |
| ----- | -------------------------- |
| DEFINE | What are we building and why? |
| PLAN | How will we build it? |
| BUILD | Write the code |
| VERIFY | Does it work? |
| REVIEW | Is it ready to merge? |
| SHIP | Get it out the door |

A skill belongs to the phase where it's *primarily* useful. Cross-cutting skills (`brief`, `context-engineer`, `caveman`) live outside the phase grouping.

## Authoring checklist

Before opening a PR with a new skill:

- [ ] Folder name matches `name:` field
- [ ] Description has three sentences (what, when, when-not)
- [ ] Body has Workflow + Rules + Error Handling sections
- [ ] No `compatibility:` or `allowed-tools:` legacy fields
- [ ] Added to the README skills table under the correct phase
- [ ] Added to `AGENTS.md` intent → skill mapping
- [ ] Cross-refs to neighbor skills use relative paths (e.g., `[validate-code](../validate-code/SKILL.md)`)
- [ ] Existing skills don't already cover this use case

## Where to start

Use the [`write-a-skill`](../skills/write-a-skill/SKILL.md) skill itself to scaffold a new one — it walks through the structure interactively.
