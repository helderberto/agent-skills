---
name: checks
description: "Pre-commit quality gate: auto-fix formatting/lint, verify types, run tests. Use when user asks to \"run checks\", \"/checks\", \"verify before commit\", or wants to validate code quality. Don't use for committing, pushing, or writing new tests."
---

# Checks

## Pre-loaded context

- Scripts: !`cat package.json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get('scripts',{})))" 2>/dev/null || echo "no package.json"`

## Workflow

1. Read `package.json` scripts to confirm available scripts
2. **Format + lint fix**: run `npm run lint-fix` or `npm run lint:fix` (whichever exists)
3. **Lint + types**: run `npm run lint` (runs `tsc --noEmit` + eslint)
4. **Tests**: run `npm test`
5. Report overall **PASS** or **FAIL** with file:line error references

## Rules

- Always auto-fix before reporting errors
- Run lint-fix → lint check → test sequentially
- If lint-fix fails, still run lint check and tests; report all failures at the end
- Report errors as `file:line` references
- Never commit, stage, or push anything

## Error Handling

- If no `package.json` → report and stop
- If neither `lint-fix` nor `lint:fix` script exists → skip fix, still run `lint`
- If `lint` script missing → skip lint entirely, note it was skipped
- If `test` script missing → skip tests, note it was skipped
- If all scripts missing → report nothing to run, stop
- If tests time out → report and suggest increasing `--testTimeout` in runner config
- If runner crashes (exit code other than 0 or 1) → report crash output and stop
