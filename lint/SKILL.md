---
name: lint
description: Run linting and formatting checks. Use when user asks to "run linter", "/lint", "check linting", "fix lint errors", or requests code linting/formatting.
---

# Linting

## Package manager detection

Check lockfile: `bun.lock` → bun, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm.

## Linter detection

Check `package.json` devDependencies:
- `@biomejs/biome` → `{pm} run check` / fix: `{pm} run check --write`
- `oxlint` → `{pm} run lint` / fix: `{pm} run lint --fix`
- `eslint` (default) → `{pm} run lint` / fix: `{pm} run lint:fix`

## Workflow

1. Detect package manager and linter
2. Run lint command
3. For fixes: run fix variant (only when requested)
4. Report `file:line` references for all errors

## Rules

- Use project's `package.json` scripts
- Never use `npx`/`bunx` directly
- Don't auto-fix unless requested
