---
name: lint
description: Run linting and formatting checks. Use when user asks to "run linter", "/lint", "check linting", "fix lint errors", or requests code linting/formatting. Don't use for running tests, type-checking only, or projects without a lint script in package.json.
disable-model-invocation: true
---

# Linting

## Linter detection

Check `package.json` devDependencies:

- `eslint` (default) → `npm run lint` / fix: `npm run lint:fix`

## Workflow

1. Detect linter from devDependencies
2. Run lint command
3. For fixes: run fix variant (only when requested)
4. Report `file:line` references for all errors

## Rules

- Use project's `package.json` scripts, never `npx` directly

## Error Handling

- If no lint script found in `package.json` → check `scripts` for alternative names (`check`, `lint:check`); report if none exist
- If linter exits with parse errors → report each file-level parse error separately with `file:line`
- If linter config file is missing → report which config file is expected and stop
