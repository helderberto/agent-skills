---
name: verify-plan
description: Verify implementation against a plan — shows progress and finds blockers. Use after /build, or when the user asks to check plan progress or what's left. Don't use to implement phases (use /build) or for general test runs (use /validate-code).
argument-hint: '[slug]'
---

# Verify Plan

Verify plan checkboxes against the codebase. Unmark items that don't hold up (`[x]` → `[ ]`).

**Interactive prompts**: present options as a numbered list and wait for the user's choice.

## Input

The argument (if provided) is: $ARGUMENTS

Use the argument as `<slug>` if given. Accepts slug or `@file` reference.

If no argument is provided, list available plans as numbered options and wait for the user's choice.

## Progress Algorithm

Count `- [x]` and `- [ ]` lines under each `## Phase N` heading. Per-phase: `Phase N — title: checked/total`. Sum → `Total: checked/total`.

## Workflow

### 1. Load the plan

Read `.specs/plans/<slug>.md`. If missing, list plans as numbered options and wait for the user's choice.

### 2. Fast-path: check if implementation exists

If primary module file(s) from Phase 1 don't exist, skip subagent — report `0/N — not yet started`, list Phase 1 done-when items.

### 3. Launch read-only review

Use a **general-purpose subagent** (not `code-review`). The subagent must be **read-only** (no file writes, no edits). It should:

1. Read every section of the plan — architectural decisions, each phase, done-when checkboxes
2. For each phase, check every `- [ ]` / `- [x]` item against the codebase
3. Run the project's test suite and include pass/fail results
4. For each checkbox, determine whether it should be checked (`[x]`) or unchecked (`[ ]`)

Collect findings into two categories:

- **BLOCKERS** — checked items that don't hold up, failing tests, broken contracts
- **SUGGESTIONS** — improvements, minor gaps, style issues

### 4. Update checkboxes

Using the subagent's report, update each checkbox in `.specs/plans/<slug>.md`:

- Items that pass verification → `[x]`
- Items that fail verification → `[ ]` (unmark)

### 5. Report

Count progress per phase (Progress Algorithm), then print:

```text
## Verification: <slug>

### Progress

  Phase 1 — title: checked/total
> Phase 2 — title: checked/total
  Total: checked/total
```

The `>` marks the first incomplete phase (cursor).

```text
### BLOCKERS

- (list or "None")

### SUGGESTIONS

- (list or "None")
```

If all items verified (total checked = total):

> All phases complete — implementation verified.

### 6. Next steps

If blockers exist, list items to fix, then re-run `/verify-plan <slug>`.

If all items verified, suggest creating a PR or shipping.

## Rules

- The review subagent must be **read-only** — it must not create, edit, or delete any files
- The only file writes this skill makes are: checkbox updates in the plan
- Never modify implementation code — only observe and report
