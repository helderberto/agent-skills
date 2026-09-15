---
name: create-skill
description: Create or restructure agent skills — frontmatter, description routing, progressive disclosure. Use when asked to create, write, or build a new skill, or "make a skill for X". Don't use for eval-driven trigger optimization (skill-creator) or one-off prose edits to a skill.
---

# Creating Skills

Read 1–2 neighboring skills first to match conventions. Draft `SKILL.md`, review it with the user against the checklist at the end.

## Layout

`skill-name/SKILL.md` is the entry point and the only required file. Push long-form docs to `references/<topic>.md` (linked, loaded on demand), deterministic helpers to `scripts/`, output templates to `assets/`. Split when `SKILL.md` passes ~150 lines or content has distinct domains (e.g. one variant per reference file so the agent loads only the relevant one).

Three disclosure levels: `name` + `description` (always in context — the sole routing signal) → `SKILL.md` body (loaded on trigger) → bundled resources (loaded on demand).

## Body shape

A body is **steps** (ordered actions), **reference** (rules and definitions consulted on demand), or both — let the content pick the shape. Don't force `Workflow` / `Rules` / `Error Handling` headings onto a skill that doesn't need them; empty scaffolding is a no-op.

Every step ends on a **completion criterion** the agent can check ("every error path returns a typed result", not "handle the errors") and that is exhaustive where it matters ("every modified file has a test"). A vague criterion invites premature completion.

## Frontmatter

| Field | Notes |
|---|---|
| `name` | kebab-case, matches directory. No version suffixes — evolve in place |
| `description` | The only routing signal for a model-invoked skill (see below) |
| `argument-hint` | Shown next to the name, e.g. `'[slug]'`, `'<idea>'` |
| `disable-model-invocation` | `true` = user-invoked only; the description becomes a one-sentence human summary |
| `effort` | `low` / `medium` / `high` / `xhigh` / `max` for the turn the skill fires; set only when it deviates from the `medium` default |
| `allowed-tools` | Tools pre-approved for the invoking turn — use sparingly |

Effort routing: `low` for mechanical single-place edits (`prose-fix`, `commit`); `high` for multi-file features, unknown-cause debugging, review (`build`, `diagnose`); `xhigh` for architecture, migrations, security-sensitive work (`architecture-audit`, `harden`).

## Description

Third person, ≤ ~350 chars, three sentences: what it does; `Use when [triggers]`; `Don't use for [anti-triggers]` pointing at neighbor skills. The agent picks among every installed skill's description — vague phrasing ("helps with documents") gives it nothing to distinguish.

Triggers are how users actually talk (phrases, file types, contexts), not the slash name — `/name` always works and costs tokens in the description. Claude under-triggers more than it over-triggers: if a useful skill rarely fires, make the trigger clause more generous.

Description anti-triggers are the one place negation earns its keep — `Don't use for X` routes correctly.

## Writing style

- Imperative form (`Run X`, not `You should run X`). Explain the why instead of stacking `ALWAYS`/`NEVER` in caps; one `MUST` for a hard constraint is fine, a wall of caps is a yellow flag.
- **Leading words**: anchor behavior with compact pretrained concepts (`tight`, `red`, `deep`, `surgical`) reused across the skill. One word carries distributed meaning and doubles as a trigger when it appears in prompts or code. Strengthen a weak word rather than piling on rules.
- **No-op test**: delete any sentence that doesn't change the model's default behavior. Prefer deletion to rewriting.
- **Prompt the positive**: state the target behavior — "don't think of an elephant" names the elephant. Keep a prohibition only as a hard guardrail you can't phrase positively, paired with what to do instead.

## Failure modes

Diagnose a misbehaving skill against these:

- **Premature completion** — a step ends before it's done. Sharpen the completion criterion first; only if irreducibly fuzzy *and* you see the rush, split later steps out of view.
- **Duplication** — the same meaning in two places. Keep one source of truth.
- **Sediment** — stale layers that accumulate because adding feels safe and removing feels risky.
- **Sprawl** — too long even when every line is live. Push reference into `references/`, split by variant.
- **No-op** — a line the model already obeys. Delete it. A weak leading word (`be thorough`) is a no-op; the fix is a stronger word (`relentless`).
- **Negation** — steering by prohibition; see Prompt the positive.

## Checklist

- [ ] Folder name matches `name:`
- [ ] Description: model-invoked → what / use when / don't use; user-invoked → one sentence
- [ ] Body shape fits the content; every step has a checkable completion criterion
- [ ] `effort` set only when it deviates from `medium`
- [ ] `SKILL.md` under ~150 lines
- [ ] Cross-refs to neighbor skills use bare `/<skill-name>` (portable across agents) or a relative link
- [ ] Added to README and the `AGENTS.md` intent → skill mapping; no existing skill already covers it
