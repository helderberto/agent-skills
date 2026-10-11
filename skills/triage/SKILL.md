---
name: triage
description: Ask which skill or flow fits your situation — a router over the hb skills.
disable-model-invocation: true
argument-hint: '<situation>'
---

# Triage

Map the situation in `$ARGUMENTS` (empty → ask what the user is trying to do) to the skill or flow that fits, and end on the one command to type next. Before you say what a skill does or recommend skipping one, read its SKILL.md: the summaries below are orientation only.

## Main flow

`grill → to-spec → to-tickets → build → review → ship → to-pr → retro`

- `/grill` sharpens the idea; `/to-spec` writes it to `.specs/specs/<slug>.md`, grilling only what's still open.
- A question that needs a runnable answer (a state model, a UI you have to see) → `/prototype` first.
- `/to-tickets` slices the spec into phases. `/build` implements one phase per run, test-first through `/tdd`; `--all` runs every phase after one approval.
- `/review` verifies and is the QA pass, `/ship` gates, commits, and pushes, `/to-pr` opens the PR.
- `/retro` closes the loop, in the same session, before `/clear`.

Small, crisp change that needs no spec → `/tdd`, then `/review`.

## On-ramps

- Something broken, flaky, or slow → `/debug`, then `/retro`.
- Review comments piling up on a PR → `/feedback`, then `/tdd` for the Address items.
- Spare time for upkeep → `/architecture-audit`; a picked candidate becomes an idea for `/grill`.
- Existing code that needs tests, splitting, or simplifying → `/refactor`.

## Vocabulary underneath

- `/codebase-design` — deep-module vocabulary for a module's shape.
- `/domain-modeling` — the project's domain language, kept in `GLOSSARY.md`.

## Standalone

- Audits: `/a11y-audit`, `/i18n`, `/perf-audit`, `/deps-audit`, `/safe-repo`, `/harden`
- Review: `/code-review` (one lens; a PR or a pasted diff), `/visual-review` (annotated HTML)
- Verify: `/check`, `/visual-review` (`--ui` for a real browser), `/tdd` (end-to-end tests too)
- Build helpers: `/source-driven`, `/frontend-ui-engineering`
- Git: `/commit`, `/to-adr`
- Session: `/handoff`, `/wait-what`, `/research`, `/zoom-out`, `/teach`
- Writing: `/revise`, `/create-skill`

## Phase boundaries

Decide at a boundary, never mid-phase: mid-phase, continue or split the rest into subagents. Work top to bottom; the first yes wins.

1. **Continue** — the next phase needs this one as a primary source, or there's room left in the context window.
2. **`/clear`** — nothing here matters to what's next.
3. **`/handoff`** — only for a new harness, a new directory, a colleague, or a side task found mid-phase.
4. **Subagent** — the task can run AFK, like an automated review.
5. **`/compact`** with an instruction (`/compact we're going to QA this area`).

Every move but Continue replaces the session with a summary of it, so rule Continue out first.
