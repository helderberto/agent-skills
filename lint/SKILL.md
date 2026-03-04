---
name: lint
description: Run linting and formatting checks. Use when user asks to "run linter", "/lint", "check linting", "fix lint errors", or requests code linting/formatting.
compatibility: Requires npm with a lint script
allowed-tools: Bash(npm:*) Read Glob
---

# Linting

## Linter detection

Check `package.json` devDependencies:
- `@biomejs/biome` → `npm run check` / fix: `npm run check --write`
- `oxlint` → `npm run lint` / fix: `npm run lint --fix`
- `eslint` (default) → `npm run lint` / fix: `npm run lint:fix`

## Workflow

1. Detect linter from devDependencies
2. Run lint command
3. For fixes: run fix variant (only when requested)
4. Report `file:line` references for all errors

## Rules

- Use project's `package.json` scripts
- Never use `npx` directly
- Don't auto-fix unless requested
