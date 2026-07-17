---
name: validate-code
description: "Validate code quality: auto-fix formatting/lint, verify types, run tests. Use when user asks to \"validate code\", \"/validate-code\", \"check code\", or wants to validate before committing. Don't use for committing, pushing, or writing new tests."
---

# Validate Code

## Workflow

1. Read `package.json` to identify available scripts
2. **Format + lint fix**: run `npm run lint-fix` or `npm run lint:fix` (whichever exists). These rewrite files in place and exit 0 silently — so capture what changed right after (`git diff --stat`, or `git status --short` if not yet committed) and remember it for the report. The user is about to commit; they need to know their working tree was modified.
3. **Lint + types**: run `npm run lint` (runs `tsc --noEmit` + eslint)
4. **Tests**: run `npm test`
5. Report: an **Auto-fixed** section listing the files lint-fix changed (or "nothing auto-fixed"), then overall **PASS** or **FAIL** with `file:line` error references

## Rules

- Always auto-fix before reporting errors — but never modify files silently; always report which files auto-fix changed
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
