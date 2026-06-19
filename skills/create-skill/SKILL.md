---
name: create-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill, or asks "make a skill for X".
---

# Creating Skills

## Process

1. **Gather requirements** — ask the user (use AskUserQuestion when available; otherwise present numbered options):
   - What task or domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts, or just instructions?
   - Any reference material to include?
2. **Explore existing skills** — `ls skills/` and read 1–2 neighbors to match conventions.
3. **Draft** — create `SKILL.md`; split deep material into `references/` if it exceeds ~150 lines; add `scripts/` only for deterministic helpers.
4. **Review with user** — present the draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more or less detailed?

## Skill Structure

```
skill-name/
├── SKILL.md              # Required. Metadata + instructions.
├── references/           # Optional. Long-form docs the agent reads on demand.
│   └── <topic>.md
├── scripts/              # Optional. Deterministic helpers (.sh, .py) called via Bash.
│   └── helper.sh
└── assets/               # Optional. Files used in output (templates, icons, fonts).
    └── template.md
```

Keep the entry point in `SKILL.md`. Link from `SKILL.md` to `references/<topic>.md` rather than inlining — preserves progressive disclosure.

### Progressive disclosure (three levels)

1. **Metadata** (`name` + `description`) — always in context (~100 words). Sole signal for triggering.
2. **`SKILL.md` body** — loaded when skill triggers. Keep under ~150 lines; the spec ceiling is ~500.
3. **Bundled resources** (`references/`, `scripts/`, `assets/`) — loaded on demand or executed without loading.

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
[if X — do Y]
```

Orchestrator skills (e.g. `review`, `ship`) replace `Workflow` with explicit phases that announce each sub-skill being invoked.

## Frontmatter Fields

| Field | Required | Notes |
|---|---|---|
| `name` | yes | kebab-case, matches directory. Avoid version suffixes (`-v2`, `-new`) — evolve in place or deprecate |
| `description` | yes | Agent's only signal for when to auto-load a model-invoked skill |
| `argument-hint` | no | One-line hint shown next to the skill name (e.g. `'[slug]'`, `'<idea>'`) |
| `disable-model-invocation` | no | `true` = user-invoked only (never auto-triggers) — see Description Requirements |

Avoid `compatibility:` and `allowed-tools:` — legacy `npx skills` CLI fields, not part of the Claude Code plugin spec.

## Description Requirements

The description is **the only thing the agent sees** when deciding which skill to load. It's surfaced in the system prompt alongside every other installed skill — the agent reads descriptions and picks one based on the user's request.

**Goal**: give the agent just enough to know

1. What capability the skill provides
2. When and why to trigger it (keywords, contexts, file types)
3. When NOT to use it (anti-triggers that point at neighbor skills)

**Format**:

- Max 1024 chars
- Third person
- First sentence: what it does
- Second sentence: `Use when [triggers]`
- Third sentence: `Don't use for [anti-triggers]`

The trigger/anti-trigger sentences exist for **model routing**. A **user-invoked** skill (`disable-model-invocation: true`) never auto-triggers — the user types it — so those clauses are dead weight that still burns context tokens every turn. Keep user-invoked descriptions to one what-it-does sentence (plus a sequencing cross-ref like `Use after /prd` if it helps). The rules below apply only to model-invoked skills.

**Combat under-triggering** (model-invoked): Claude tends to under-trigger skills. If a skill is useful but rarely fires, make the description more assertive — list extra phrases the user might say, name file types or contexts explicitly, even add `Make sure to use this skill whenever...` when warranted. Anti-triggers stay important, but the trigger clause should be generous.

**Good**:

```
Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction. Don't use for image OCR (use vision skill) or DOCX files.
```

**Bad**:

```
Helps with documents.
```

The bad example gives the agent no way to distinguish this from any other document skill.

## When to Add Scripts

Add `scripts/` helpers when:

- The operation is deterministic (validation, scanning, formatting)
- The same logic would otherwise be regenerated on every invocation
- Errors need explicit handling and predictable exit codes

Scripts save tokens and improve reliability vs. ad-hoc generated code.

## When to Split Files

Split into `references/<topic>.md` when:

- `SKILL.md` exceeds ~150 lines
- Content has distinct domains (e.g. patterns vs. report template)
- Advanced material is rarely needed during the main workflow

**Domain organization**: when a skill supports multiple variants, split by variant so the agent loads only the relevant one:

```
cloud-deploy/
├── SKILL.md              # workflow + variant selection
└── references/
    ├── aws.md
    ├── gcp.md
    └── azure.md
```

## Writing Style

- **Imperative form** for instructions (`Run X`, `Check Y` — not `You should run X`)
- **Explain the why** instead of stacking `ALWAYS`/`NEVER` in caps. Today's models have theory of mind; reasoning lands better than rigid rules
- A single `MUST` is fine when a hard constraint exists; a wall of caps is a yellow flag — reframe and explain
- **Leading words**: anchor behavior with compact, pretrained concepts (`tight`, `red`, `deep`, `surgical`) reused across the skill. One word carries distributed meaning in few tokens and doubles as a trigger when it appears in prompts or code. Strengthen a weak word rather than piling on more rules
- **No-op test**: delete any sentence that doesn't change default behavior. Prefer deletion to rewriting — stale layers accumulate otherwise

## Review Checklist

Before shipping a new or modified skill:

- [ ] Folder name matches `name:` field
- [ ] Description: model-invoked → three sentences (what, when, when-not); user-invoked → one what-it-does sentence
- [ ] Body has Workflow + Rules + Error Handling sections
- [ ] `SKILL.md` under ~150 lines (split into `references/` if longer)
- [ ] Concrete examples included
- [ ] No time-sensitive info (versions, dates)
- [ ] No `compatibility:` or `allowed-tools:` legacy fields
- [ ] Cross-refs to neighbor skills use relative paths (e.g. `[validate-code](../validate-code/SKILL.md)`)
- [ ] When a skill references invoking another skill, use bare `/<skill-name>` (not `/hb:`) — portable across agents; required for user-invoked skills (`disable-model-invocation: true`) since they don't auto-trigger
- [ ] Added to README skills table under the correct phase
- [ ] Added to `AGENTS.md` intent → skill mapping
- [ ] No existing skill already covers this use case
