---
name: test
effort: high
description: VERIFY phase — prove the code works. Run validation (lint, types, tests) plus coverage on changes, and when a plan exists verify its checkboxes against the codebase. Use after /build, when the user asks to verify, test, or confirm work holds up, or to check plan progress. Don't use to implement phases (use /build) or write new tests from scratch (use /tdd).
argument-hint: '[slug]'
---

# Test — Verify

Tests are proof. Confirm the code actually works, then — if a plan exists — verify its claims against the codebase. Works for frontend and backend alike; validation and coverage run against whatever test runner the project uses.

**Interactive prompts**: present options as a numbered list and wait for the user's choice.

## Input

The argument (if provided) is: $ARGUMENTS

Accepts a plan `<slug>` or `@file` reference. If omitted, glob `.specs/plans/*.md`:

- one plan → use it
- several → list as numbered options and wait for the user's choice
- none → run validation only (skip plan verification)

## Workflow

### 1. Validate (always)

Run and collect all results — don't stop at the first failure:

1. `/validate-code` — auto-fix formatting/lint, verify types, run the full test suite
2. **Changed-line coverage** — if the project emits coverage, confirm the lines you changed (`git diff -U0`) are exercised, not just the global %. Skip when the project has no coverage tooling.

Capture pass/fail and any uncovered changed lines.

### 2. Load the plan (if any)

Read `.specs/plans/<slug>.md`. If there is no plan, skip to Report with just the validation results.

**Fast-path**: if the primary module file(s) from Phase 1 don't exist, report `0/N — not yet started`, list Phase 1 done-when items, skip the subagent.

### 3. Verify plan claims (read-only subagent)

Launch a **general-purpose subagent** (not `code-review`). It must be **read-only** — no writes, no edits. It should:

1. Read every section of the plan — architectural decisions, each phase, done-when checkboxes
2. Check every `- [ ]` / `- [x]` item against the codebase
3. Fold in the Step 1 test results
4. Decide, per checkbox, whether it holds (`[x]`) or not (`[ ]`)

Collect findings into two categories:

- **BLOCKERS** — checked items that don't hold up, failing tests, broken contracts
- **SUGGESTIONS** — improvements, minor gaps, style issues

### 4. Update checkboxes

In `.specs/plans/<slug>.md`: items that pass → `[x]`, items that fail → `[ ]` (unmark). This is the only file write this skill makes.

## Progress Algorithm

Count `- [x]` and `- [ ]` lines under each `## Phase N` heading. Per-phase: `Phase N — title: checked/total`. Sum → `Total: checked/total`.

### 5. Report

```text
## Verify: <slug>

### Validation
- validate-code: pass/fail (detail)
- coverage: X% of changed lines (uncovered: ...)

### Progress            (omit if no plan)
  Phase 1 — title: checked/total
> Phase 2 — title: checked/total
  Total: checked/total

### BLOCKERS
- (list or "None")

### SUGGESTIONS
- (list or "None")
```

The `>` marks the first incomplete phase (cursor).

If validation is green and all items verified (total checked = total):

> All phases complete — implementation verified.

### 6. Next steps

- Blockers → list items to fix, then re-run `/test <slug>`
- Clean → `/review` is an optional QA pass for non-trivial changes (not a ship gate — `/ship` runs its own validate-code + safe-repo gate), then `/ship`

## Rules

- The verification subagent must be **read-only** — no create, edit, or delete
- The only file writes this skill makes are checkbox updates in the plan
- Never modify implementation code — only observe and report
