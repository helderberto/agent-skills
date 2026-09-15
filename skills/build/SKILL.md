---
name: build
effort: high
description: Implement the next unblocked phase of a plan with feedback loops, mark its checkboxes, offer a commit. Use after /plan when `.specs/plans/<slug>.md` exists, or when asked to build the next phase. Don't use for unplanned changes (/tdd) or to check progress (/test).
argument-hint: '[slug]'
---

# Build Phase

Implement the next incomplete phase of a plan — one phase per invocation.

## Input

`$ARGUMENTS` is a `<slug>` or an `@path` (read that file directly as the plan). If empty or the plan is missing, list `.specs/plans/*.md` as numbered options and wait.

## Workflow

### 1. Find the next incomplete phase

Scan `## Phase N` headings and count `- [ ]` / `- [x]`. The next incomplete phase is the first with an unchecked item **and** whose `**Blocked by**` phases (if declared) are all complete. If the first incomplete phase is blocked, pick the next unblocked one and say why.

All phases complete → "All phases complete. Run `/test <slug>` to verify." Stop.

### 2. Present the phase

Show the title and unchecked items. If on the default branch, offer to create `feat/<slug>` (Recommended) before touching code.

### 3. Implement

For each unchecked item, in order: read the plan's architectural decisions and the item's context, explore the surrounding code, implement following the project's conventions (CLAUDE.md, linter, test setup), write tests alongside.

Stay inside the phase boundary — never implement items from other phases. Never impose conventions the project doesn't already use.

### 4. Feedback loops

Detect and run the project's checks (types, tests, lint, format) — prefer tasks the project defines; detection table in [validate-code](../validate-code/SKILL.md). Fix and re-run until green. A check still failing after 3 attempts is a **blocker**: report the last error and ask whether to wait, skip the check, or abort the phase.

Anything the agent cannot provide (API key, external service, manual setup, design decision) is also a blocker — ask, never work around it silently.

### 5. Mark checkboxes

Flip completed items `- [ ]` → `- [x]` in the plan. This is the only plan edit; the spec is read-only.

### 6. Offer commit

"Phase N complete — all checks pass. Commit?" If yes: stage implementation files by name (not `.specs/` unless the project commits specs), commit in the project's convention, never push. Then: "Run `/build <slug>` for Phase N+1, or `/test <slug>` to verify."
