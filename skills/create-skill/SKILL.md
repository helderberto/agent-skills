---
name: create-skill
description: Create new agent skills with proper structure, progressive disclosure, and bundled resources. Use when user wants to create, write, or build a new skill, or asks "make a skill for X". Don't use for benchmarking or optimizing a skill's triggering with evals (use skill-creator), or for one-off prose edits to an existing skill.
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

[body — steps, reference, or both]
```

A skill's body is built from two content types that mix freely: **steps** (ordered actions the agent takes) and **reference** (definitions, rules, facts consulted on demand). A skill can be all steps, all reference, or both — let the content pick the shape. Don't force `Workflow` / `Rules` / `Error Handling` headings onto a skill that doesn't need them; empty scaffolding sections are no-ops (see Failure Modes).

- **Step-shaped** skills (e.g. `build`, `diagnose`): number the actions in order. Orchestrators (`review`, `ship`) use explicit phases that announce each sub-skill invoked.
- **Reference-shaped** skills (e.g. `codebase-design`): a flat peer-set of rules under headings is fine, not a smell.

### Completion criteria

Every step ends on a **completion criterion** — the condition that tells the agent the step is done. Make it:

- **Checkable** — the agent can tell done from not-done (not "handle the errors" but "every error path returns a typed result").
- **Exhaustive** where it matters — "every modified file has a test", not "add some tests". A vague criterion invites premature completion (see below).

## Frontmatter Fields

| Field | Required | Notes |
|---|---|---|
| `name` | yes | kebab-case, matches directory. Avoid version suffixes (`-v2`, `-new`) — evolve in place or deprecate |
| `description` | yes | Agent's only signal for when to auto-load a model-invoked skill |
| `argument-hint` | no | One-line hint shown next to the skill name (e.g. `'[slug]'`, `'<idea>'`) |
| `disable-model-invocation` | no | `true` = user-invoked only (never auto-triggers) — see Description Requirements |
| `effort` | no | Override reasoning effort for the current turn: `low` / `medium` / `high` / `xhigh`. Match it to task complexity — see Effort Routing |

Avoid `compatibility:` and `allowed-tools:` — legacy `npx skills` CLI fields, not part of the Claude Code plugin spec. `model:` is documented but **ignored at runtime for skills** (works for subagents only) — don't set it.

## Effort Routing

A skill's `effort` overrides session effort for the turn it fires, then resets. Set it so trivial work runs cheap and hard work runs deep, without the user touching `/effort`. Only mark a skill when it deviates from the `medium` default — leave medium skills unmarked to keep frontmatter quiet.

| Effort | Fits | Examples |
|---|---|---|
| `low` | mechanical, single-place edits | `prose-fix`, `lint`, `commit`, `coverage` |
| `medium` | single-file additions, known-cause fixes (implicit default — leave unset) | `tdd`-adjacent, `e2e`, `source-driven` |
| `high` | multi-file features, unknown-cause debugging, refactors, review | `build`, `plan`, `diagnose`, `code-review` |
| `xhigh` | architecture, migrations, security-sensitive work | `architecture-audit`, `harden` |

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

The trigger/anti-trigger sentences exist for **model routing**. A **user-invoked** skill (`disable-model-invocation: true`) never auto-triggers — the user types it — so those clauses are dead weight that still burns context tokens every turn. Keep user-invoked descriptions to one what-it-does sentence (plus a sequencing cross-ref like `Use after /spec` if it helps). The rules below apply only to model-invoked skills.

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
- **Prompt the positive**: state the target behavior, not the banned one — "don't think of an elephant" names the elephant. Keep a prohibition only as a hard guardrail you can't phrase positively, and even then pair it with what to do instead. (Description anti-triggers are the exception — `Don't use for X` routes correctly and stays.)

## Failure Modes

Diagnose a misbehaving skill against these — most problems are one of them:

- **Premature completion** — the agent stops a step before it's genuinely done, attention slipping to *being done*. Fix the completion criterion first (sharpen, make exhaustive); only if it's irreducibly fuzzy *and* you see the rush, split the later steps out of view so the agent can't race ahead.
- **Duplication** — the same meaning in more than one place. Costs tokens and maintenance, and inflates the meaning's apparent importance. Keep one source of truth.
- **Sediment** — stale layers that accumulate because adding feels safe and removing feels risky. The default fate of any skill without pruning discipline.
- **Sprawl** — simply too long, even when every line is live. Cure with progressive disclosure (push reference into `references/`) and splitting by variant.
- **No-op** — a line the model already obeys by default. Delete it. A weak leading word (`be thorough` when the agent already is) is a no-op; the fix is a stronger word (`relentless`), not more rules.
- **Negation** — steering by prohibition, which backfires (see Prompt the positive).

## Review Checklist

Before shipping a new or modified skill:

- [ ] Folder name matches `name:` field
- [ ] Description: model-invoked → three sentences (what, when, when-not); user-invoked → one what-it-does sentence
- [ ] Body shape fits the content (steps, reference, or both) — no empty scaffolding sections
- [ ] Every step has a checkable completion criterion; exhaustive where it matters
- [ ] `effort` set if the task deviates from the `medium` default (low for mechanical, high/xhigh for heavy)
- [ ] `SKILL.md` under ~150 lines (split into `references/` if longer)
- [ ] Concrete examples included
- [ ] No time-sensitive info (versions, dates)
- [ ] No `compatibility:` or `allowed-tools:` legacy fields
- [ ] Cross-refs to neighbor skills use relative paths (e.g. `[validate-code](../validate-code/SKILL.md)`)
- [ ] When a skill references invoking another skill, use bare `/<skill-name>` (not `/hb:`) — portable across agents; required for user-invoked skills (`disable-model-invocation: true`) since they don't auto-trigger
- [ ] Added to README skills table under the correct phase
- [ ] Added to `AGENTS.md` intent → skill mapping
- [ ] No existing skill already covers this use case
