---
name: test
effort: high
description: VERIFY phase — run validation (lint, types, tests) plus changed-line coverage, and when a plan exists verify its checkboxes against the codebase. Use after /build, when the user asks to verify, test, or confirm work holds up, or to check plan progress. Don't use to implement phases (/build) or write new tests (/tdd).
argument-hint: '[slug]'
---

# Test — Verify

Tests are proof. Confirm the code works, then — if a plan exists — verify its claims against the codebase.

## Input

`$ARGUMENTS` is a plan `<slug>` or `@file`. If omitted, glob `.specs/plans/*.md`: one → use it; several → list as options; none → validation only.

## Workflow

### 1. Validate (always)

Collect all results — don't stop at the first failure:

1. `/validate-code` — auto-fix formatting/lint, verify types, full suite
2. **Changed-line coverage** — if the project emits coverage, confirm the lines you changed (`git diff -U0`) are exercised, not just the global %. Skip without coverage tooling.

### 2. Verify plan claims (if a plan exists)

**Fast-path**: if the primary module file(s) from Phase 1 don't exist, report `0/N — not yet started`, list Phase 1 done-when items, and skip the subagent.

Otherwise launch a **read-only general-purpose subagent** (no writes) that reads every plan section, checks every `- [ ]` / `- [x]` against the codebase, folds in the Step 1 results, and decides per checkbox whether it holds. Findings split into **BLOCKERS** (checked items that don't hold, failing tests, broken contracts) and **SUGGESTIONS**.

### 3. Update checkboxes

In the plan: passing → `[x]`, failing → `[ ]`. This is the only file write this skill makes — never touch implementation code.

### 4. Report

```text
## Verify: <slug>

### Validation
- validate-code: pass/fail (detail)
- coverage: X% of changed lines (uncovered: ...)

### Progress            (omit if no plan; `>` marks the first incomplete phase)
  Phase 1 — title: checked/total
> Phase 2 — title: checked/total
  Total: checked/total

### BLOCKERS
### SUGGESTIONS
```

All green and every item verified → "All phases complete — implementation verified."

Next: blockers → fix, re-run `/test <slug>`. Clean → `/review` is an optional QA pass (not a ship gate — `/ship` runs its own), then `/ship`.
