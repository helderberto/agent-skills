---
name: code-simplify
description: Simplify working code without changing behavior — reduce complexity, remove dead abstractions, favor clarity over cleverness. Use when code works but is harder to read or maintain than it should be, or the user asks to "simplify", "clean up", "reduce complexity", or "make this clearer". Don't use to add features or backfill tests (use /tdd or /fortify), design a new interface (use /codebase-design), or review a PR (use /code-review).
---

# Code Simplify

Make working code clearer without changing what it does. Clarity over cleverness. Behavior is frozen — the test suite is the contract. Applies to frontend and backend equally.

Target: $ARGUMENTS (file, directory, or module — if blank, use unstaged changes)

## Guardrails

- **Chesterton's Fence** — before removing anything, explain why it's there. If you can't, leave it and flag it. Never delete guards, checks, or branches you don't understand.
- **Behavior is frozen** — no functional changes. Green test suite before and after; if a test's meaning has to change, you've gone too far.
- **Clarity over cleverness** — a junior should read it without decoding. Prefer boring and obvious.

## Workflow

### 1. Baseline

- Identify target files (blank → unstaged changes)
- Run the test suite. If red, stop — don't simplify broken code
- If a target has no tests, flag it: simplification is unverifiable without them (offer `/fortify`)

### 2. Audit

List findings, most-impactful first:

| Smell | Simplification |
|---|---|
| Deep nesting (> 2 levels) | Guard clauses / early return |
| Dead code, unused params, unreachable branches | Delete (after Chesterton's Fence) |
| Duplicated logic | Extract one named helper |
| Clever one-liners, dense ternaries | Expand to readable form |
| Shallow pass-through wrapper | Inline it (`/codebase-design` — the deletion test) |
| Speculative flexibility / config never used | Remove |
| Unclear names, primitive obsession | Rename to intent |

Present the audit. Ask **which items to apply** — list each as an option, "All items" first and marked (Recommended). Use AskUserQuestion (multiSelect) when available; otherwise a numbered checklist.

### 3. Apply — one change at a time

Per approved item:

1. Make the single change
2. Run tests — must stay green
3. If red → revert that change, flag as blocked

Never batch. Use immutable edits — introduce no new mutation.

### 4. Report

```text
## Simplify Report

### Applied
- Flattened `parseConfig` — 4 nesting levels → guard clauses
- Deleted unused `legacyMode` param (Chesterton: git blame shows the feature was removed)
- Inlined `wrapResult` pass-through (deletion test: complexity vanished)

### Skipped / Blocked
- `retryLoop` — kept the sleep; couldn't confirm why (Chesterton's Fence)

### Result
Tests: 42 passed | 0 failed | behavior unchanged
```

## Relationship to neighbors

- **Depth framing** — reach for `/codebase-design` vocabulary (deletion test, shallow module) when a simplification is really an interface question.
- **Splitting God functions or backfilling coverage** → `/fortify` (it changes structure and adds tests; this skill only removes complexity).
- **Restructuring across modules** → `/architecture-audit`.

## Rules

- Never change external behavior — simplification is internal only
- Every removal passes the Chesterton's Fence test or gets flagged, not deleted
- Skip files with no test infrastructure unless the user opts in
