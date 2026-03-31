---
name: harden
description: Harden existing code by splitting large functions, adding edge-case coverage, and backfilling unit tests. Use when user asks to "harden", "make robust", "add missing tests", "split functions", or wants to improve reliability of existing code. Don't use for new features (use tdd), refactoring plans (use refactor-plan), or code review (use code-review).
---

# Harden

Target: $ARGUMENTS (file, directory, or module — if blank, use unstaged changes)

## Pre-loaded context

- Test runner: !`node -e "const p=require('./package.json'); console.log(p.scripts?.test || 'none')"`
- Unstaged changes: !`git diff --name-only`

## Workflow

### 1. Scope

Identify target files. If $ARGUMENTS is blank, use unstaged changed files.

- Read each target file
- Read its existing test file (co-located `*.test.ts` or `__tests__/`)
- If no test file exists, note it

### 2. Audit

For each file, list findings in three buckets:

| Bucket | What to look for |
|---|---|
| **Split** | Functions > 20 lines, multiple responsibilities, deeply nested logic (> 2 levels), God functions doing I/O + logic |
| **Edge cases** | Missing null/empty/boundary checks at system boundaries, unhandled error paths, implicit assumptions |
| **Test gaps** | Untested public functions, branches with no coverage, missing sad-path tests |

Present the audit as a checklist. Ask user: **"Which items should I address?"** (default: all).

### 3. Harden (TDD loop per item)

For each approved item, apply red-green-refactor:

```
RED:    Write a failing test that exposes the gap
GREEN:  Minimal code change to pass
REFACTOR: Extract/simplify if the fix introduced complexity
```

One item at a time. Run tests after each cycle. Never batch.

**Splitting rules:**
- Extract pure logic into named helpers — keep I/O at the edges
- New functions must be testable through public interface when possible
- Preserve the original function's signature (no breaking changes)

**Test rules:**
- Test behavior, not implementation
- Each test gets a descriptive name: `it('returns empty array when input is null')`
- Prefer real values over mocks; mock only external I/O

### 4. Verify

- Run full test suite
- Confirm no regressions
- Report summary: items addressed, tests added, functions extracted

## Output format

```
## Hardening Report

### Audit
- [ ] Split: `processOrder` (45 lines, validation + persistence + notification)
- [ ] Edge: `parseConfig` — no handling for missing file
- [ ] Test: `formatOutput` — zero test coverage

### Changes
- Extracted `validateOrder()` from `processOrder()` (+1 fn, +3 tests)
- Added null-guard to `parseConfig` (+2 tests)
- Backfilled `formatOutput` tests (+4 tests)

### Result
Tests: 42 passed (was 35) | 0 failed
```

## Rules

- Never change external behavior — hardening is internal improvement
- If splitting a function would require changing its public API, flag it and ask before proceeding
- Always run tests between items — stop if anything breaks
- Skip files with zero test infrastructure unless user explicitly asks to set it up

## Error Handling

- If no test runner found → ask user which runner to use before proceeding
- If test suite fails before hardening → report failures and stop; don't harden broken code
- If a split introduces a regression → revert that split immediately, note it as blocked
- If target file has no exports (script/entrypoint) → audit only, skip test backfill unless user confirms
