---
name: coverage
description: Check test coverage for unstaged changes. Use when user asks to "check coverage", "/coverage", or wants to see which unstaged changes lack test coverage. Don't use for projects without lcov coverage output, running the full test suite without coverage, or checking coverage of already-committed changes.
---

# Coverage Check

## Context

Run in parallel:
- `git diff --name-only` - get unstaged files
- `git diff -U0 --no-color` - get changed line numbers

## Commands

Sequential:
1. `npm run test:ci` - vitest with coverage
2. `npm run coverage:report` - generate lcov/text reports

## Workflow

1. Get unstaged files and line ranges (parallel):
   - `git diff --name-only`
   - `git diff -U0 --no-color`
2. Run coverage:
   - `npm run test:ci`
   - `npm run coverage:report`
3. Save diff to a temp file, then run:
   ```bash
   git diff -U0 --no-color > /tmp/changes.diff
   python3 scripts/parse-lcov.py --lcov coverage/lcov.info --diff /tmp/changes.diff
   ```
   See [lcov-format.md](references/lcov-format.md) for lcov format details.
4. Report uncovered lines from stdout: `file.ts:42`
5. Summary from stderr: X/Y changed lines covered

## Rules

- Only analyze unstaged changes (`git diff`)
- Use sequential commands: `test:ci` then `coverage:report`
- Use `scripts/parse-lcov.py` to parse lcov data and map to changed lines
- Report uncovered lines: `file.ts:42`
- Ignore files without coverage data (non-code files)

## Error Handling

- If `npm run test:ci` fails → report test failures and stop; coverage cannot be generated with failing tests
- If `coverage/lcov.info` not found after test run → verify `coverage.reporter` includes `lcov` in the test runner config
- If `git diff` returns no changes → report no unstaged changes to check
