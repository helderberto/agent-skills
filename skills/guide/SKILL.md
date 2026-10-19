---
name: guide
description: Explain which hb skill or flow fits your situation, from a map of how the skills fit together.
disable-model-invocation: true
argument-hint: '[situation or question]'
---

# Guide

You don't remember every skill, so ask. Map `$ARGUMENTS` (empty → ask what the user is trying to do) to the skill or flow that fits, and end on one filled-in `Next:` line. Before you state what a skill does or recommend skipping one, read its SKILL.md: this map is orientation only.

## The map

A **flow** is a path through the skills. Most work runs along the **main flow**; **on-ramps** merge onto it. Everything else is standalone, or a vocabulary layer underneath.

### Main flow: idea → PR

0. **`/hb:setup`**, once per repo, picks where specs and tickets live: local markdown in `.specs/` (the default, no setup needed), GitHub, or Jira. Rerun to switch.
1. **`/hb:triage`** classifies the input, sizes it, and names the entry. S work skips to `/hb:build`; M work with a crisp ticket skips to `/hb:to-tickets`.
2. **`/hb:grill`** sharpens the idea by interview, in rounds over the design-tree frontier. It writes settled terms to `GLOSSARY.md` (via `domain-modeling`) and hard-to-reverse decisions to ADRs (via `to-adr`) as they land.
   - **A question needs a runnable answer?** A state model, business logic, a UI you have to see → detour through **`/hb:prototype`**, kept on a `prototype/<name>` branch, then back to the grill with what you learned.
3. **`/hb:to-spec`** turns the settled conversation into a spec in the configured tracker. No interview: an open branch sends you back to `/hb:grill`.
4. **`/hb:to-tickets`** slices the spec into tracer-bullet tickets in the configured tracker, each with **blocking edges**. Only exceptions get a `hitl` label.
5. **`/hb:build`** implements the next unblocked ticket test-first through `tdd`, runs `check`, and commits. `--all` fans the tickets out to parallel implementer subagents, frontier by frontier, after one approval, and stops before each `hitl` one.
6. **`/hb:review`** fans out parallel reviewers: correctness, standards, spec conformance with ticket checkboxes, test effectiveness with changed-line coverage, the quality bar, and the audits the diff calls for.
7. **`/hb:to-pr`** is the only command that publishes: gate, an optional `--safe` secret scan, push, PR body with evidence and merge danger, `gh pr create`, CI watch.
8. **`/hb:retro`** closes the loop. It suggests changes to the agent's **environment**, not the code: navigation pointers, checks, coding standards, steering files. Mechanical mistakes become checks; judgement calls become standards.

#### Context hygiene

Keep steps 2–4 in **one unbroken context window**, so the grill, the spec, and the tickets build on the same thinking. Each `/hb:build` can start fresh from its ticket: the ticket is self-contained. Run `/hb:retro` in the session it looks back on, before `/clear`.

Past the window where the model still reasons sharply (~150k tokens), don't push on degraded: `/compact` at the nearest phase boundary.

### On-ramps

- **Something's broken, flaky, or slow** → **`/hb:debug`**. It builds a feedback loop that goes red on *this* bug before any theory, then fixes with a regression test. Then `/hb:retro` asks what would have prevented it; a missing seam becomes an `/hb:architecture-audit` run.
- **Review comments piling up on your PR** → **`/hb:feedback`** sorts them into Address / Skip / Optional / Discuss, then fixes the Address items test-first.
- **Someone else's PR** → **`/hb:code-review <PR>`**: quality and spec, side by side. **`/hb:review <PR>`** for the full panel.
- **Unsure a risky change is worth it** — a PR, a branch, a plan → **`/hb:debate`**: advocate, skeptic, and neutral investigator argue it over two rounds, then one recommendation.
- **Existing code that needs tests, splitting, or simplifying** → **`/hb:refactor`**, behavior frozen.

### Codebase health

- **`/hb:architecture-audit`** surfaces deepening opportunities in git hot spots. A picked candidate becomes an improvement PRD you slice with `/hb:to-tickets`, or an idea for `/hb:grill`.

### Vocabulary underneath

Model skills that other skills pull in. Reach for them directly in plain words when the **words**, not the process, are the problem.

- **`domain-modeling`** — the project's domain language in `GLOSSARY.md`: challenge a fuzzy term, split an overloaded word.
- **`codebase-design`** — the deep-module vocabulary (module, interface, depth, seam, adapter, leverage, locality) for a module's shape.

### Standalone

- **`/hb:zoom-out`** — explain code with an analogy and a diagram.
- **`/hb:research`** — a background agent reads primary sources and leaves a cited file in `.specs/research/`. Feed it into `/hb:grill`.
- **`/hb:check`** — lint, types, tests; `--check` writes nothing.
- **`/hb:commit`** — atomic commits by concern, never a push.
- **`/hb:safe-repo`** — check a repo for secrets and sensitive data.
- **`/hb:to-adr`** — record one architectural decision.
- **`/hb:revise`** — restructure a draft or polish prose.
- **`/hb:create-skill`** — author a new skill.
- **`/hb:handoff`** — a portable doc for a new harness, directory, or colleague.
- **`/hb:wait-what`** — the last message didn't land; re-pitch it plainly in glossary terms.
- **`/hb:teach`** — learn a concept over multiple sessions in a stateful workspace.
- Model skills route themselves from plain words: test-first work (`tdd`), official-docs implementation (`source-driven`), UI construction (`frontend-ui-engineering`), accessibility, i18n, bundle size, dependency CVEs, trust boundaries, a visual diff report, a browser check.

## Phase boundaries

Decide at a boundary, never mid-phase: mid-phase, continue or split the rest into subagents. Work top to bottom; the first yes wins.

1. **Continue** — the next phase needs this one as a primary source, or there's room left in the context window.
2. **`/clear`** — nothing here matters to what's next.
3. **`/hb:handoff`** — only for a new harness, a new directory, a colleague, or a side task found mid-phase.
4. **Subagent** — the task can run AFK, like an automated review.
5. **`/compact`** with an instruction (`/compact we're going to QA this area`).

Every move but Continue replaces the session with a summary of it, so rule Continue out first.

Next: `/hb:<cmd> <args>` for the skill that fits.
