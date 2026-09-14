---
name: fortify
effort: high
description: Improve existing code without changing behavior — split large functions, backfill tests, add edge-case coverage, or simplify (flatten nesting, delete dead code, inline wrappers). Use when user asks to "fortify", "add missing tests", "split functions", "simplify", "clean up", or "reduce complexity". Don't use for new features (/tdd), security (/harden), or PR review (/code-review).
---

# Fortify

Target: $ARGUMENTS (file, directory, or module — if blank, use unstaged changes)

Behavior is frozen — the test suite is the contract. Green before and after; if a test's meaning has to change, you've gone too far.

## Workflow

### 1. Scope

- Identify target files (blank → unstaged changes)
- Locate each file's tests using the project's convention (co-located, `__tests__/`, `tests/`, `spec/`); note files with none
- Run the suite. If red, stop — don't fortify broken code

### 2. Audit

List findings, most-impactful first:

| Bucket | What to look for | Fix |
|---|---|---|
| **Split** | Functions > 20 lines, multiple responsibilities, I/O mixed with logic | Extract pure logic into named helpers; keep I/O at the edges; preserve the original signature |
| **Edge cases** | Missing null/empty/boundary checks at system boundaries, unhandled error paths | Test first, then guard |
| **Test gaps** | Untested public functions, uncovered branches, missing sad-path tests | Backfill through the public interface |
| **Simplify** | Nesting > 2 levels, dead code / unused params, duplicated logic, dense one-liners, shallow pass-through wrappers, speculative config never used | Guard clauses, delete, extract one helper, expand, inline (`/codebase-design` deletion test), remove |

**Chesterton's Fence**: before removing anything, explain why it's there. If you can't, leave it and flag it.

Present the audit as a checklist and ask which items to address — "All items" first, marked (Recommended).

### 3. Apply — one item at a time

Per approved item: RED (failing test exposing the gap, when the item adds behavior coverage) → GREEN (minimal change) → run tests. If red after the change, revert it and flag as blocked. Never batch.

### 4. Report

Items addressed, tests added, functions extracted, items skipped with reason (Chesterton), suite result before/after.
