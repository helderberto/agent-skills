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
4. Report uncovered lines from stdout: `file.ts:42`
5. Summary from stderr: X/Y changed lines covered

## LCOV Format

Parse `coverage/lcov.info`:
```
SF:src/utils/helper.ts
DA:10,1    # line 10, covered (hit 1 time)
DA:11,0    # line 11, NOT covered
DA:12,5    # line 12, covered (hit 5 times)
end_of_record
```

Key fields:
- `SF:` -- source file path
- `DA:line,hits` -- `0` = uncovered, `>0` = covered
- `end_of_record` -- end of file section

Match `SF:` paths to `git diff` files. For each changed line, check `DA:` entry. If `hits` is `0`, report as uncovered.

## Anti-Rationalization

| Excuse | Rebuttal |
|---|---|
| "Coverage doesn't guarantee quality" | True, but uncovered code guarantees zero automated verification. |
| "It's just a config change" | Config changes break production too. If there's logic, check coverage. |
| "100% is overkill" | Nobody asked for 100%. Check that *changed* lines are covered. |
| "The test suite is already green" | Green suite with uncovered changes = false confidence. |

## Rules

- Only analyze unstaged changes (`git diff`)
- Use sequential commands: `test:ci` then `coverage:report`
- Use `scripts/parse-lcov.py` to parse lcov data and map to changed lines
- Report uncovered lines: `file.ts:42`
- Ignore files without coverage data (non-code files)

## Error Handling

- `npm run test:ci` fails -- report test failures and stop
- `coverage/lcov.info` not found -- verify `coverage.reporter` includes `lcov` in test runner config
- `git diff` returns no changes -- report no unstaged changes to check
