---
name: ask
description: Ask which skill or flow fits your situation — a router over the hb skills.
disable-model-invocation: true
argument-hint: '<situation>'
---

# Ask

Map the situation in `$ARGUMENTS` (empty → ask what the user is trying to do) to the skill or flow that fits, and end on the one command to type next. Before you say what a skill does or recommend skipping one, read its SKILL.md: the summaries below are orientation only.

## Main flow

`grill-me → spec → plan → build → test → review → ship → create-pull-request → retro`

- `/grill-me` sharpens the idea; `/spec` writes it to `.specs/specs/<slug>.md`, grilling only what's still open.
- A question that needs a runnable answer (a state model, a UI you have to see) → `/prototype` first.
- `/plan` slices the spec into phases. `/build` implements one phase per run, test-first through `/tdd`; `--all` runs every phase after one approval.
- `/test` verifies, `/review` is the QA pass, `/ship` gates, commits, and pushes, `/create-pull-request` opens the PR.
- `/retro` closes the loop, in the same session, before `/clear`.

Small, crisp change that needs no spec → `/tdd`, then `/review`.

## On-ramps

- Something broken, flaky, or slow → `/diagnose`, then `/retro`.
- Review comments piling up on a PR → `/triage-review`, then `/tdd` for the Address items.
- Spare time for upkeep → `/architecture-audit`; a picked candidate becomes an idea for `/grill-me`.
- Existing code that needs tests, splitting, or simplifying → `/fortify`.

## Vocabulary underneath

- `/codebase-design` — deep-module vocabulary for a module's shape.
- `/domain-modeling` — the project's domain language, kept in `GLOSSARY.md`.

## Standalone

- Audits: `/a11y-audit`, `/i18n`, `/perf-audit`, `/deps-audit`, `/safe-repo`, `/harden`
- Review: `/code-review` (one lens; a PR or a pasted diff), `/visual-review` (annotated HTML)
- Verify: `/validate-code`, `/visual-validate`, `/e2e`
- Build helpers: `/source-driven`, `/frontend-ui-engineering`
- Git: `/commit`, `/create-adr`
- Session: `/handoff`, `/wait-what`, `/research`, `/explain-code`, `/teach`
- Writing: `/prose-fix`, `/revise`, `/create-skill`

## Phase boundaries

Decide at a boundary, never mid-phase: mid-phase, continue or split the rest into subagents. Work top to bottom; the first yes wins.

1. **Continue** — the next phase needs this one as a primary source, or there's room left in the context window.
2. **`/clear`** — nothing here matters to what's next.
3. **`/handoff`** — only for a new harness, a new directory, a colleague, or a side task found mid-phase.
4. **Subagent** — the task can run AFK, like an automated review.
5. **`/compact`** with an instruction (`/compact we're going to QA this area`).

Every move but Continue replaces the session with a summary of it, so rule Continue out first.
