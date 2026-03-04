---
name: audit-deps
description: Check dependencies for vulnerabilities. Use when user asks to "audit dependencies", "/audit-deps", "check for vulnerabilities", or wants to check dependency health.
disable-model-invocation: true
compatibility: Requires npm, bun, or pnpm
---

# Dependency Audit

## Package manager detection

Check lockfile: `bun.lock` → bun, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm.

## Commands

Run in parallel based on detected package manager:
- npm: `npm audit` + `npm outdated`
- pnpm: `pnpm audit` + `pnpm outdated`
- yarn: `yarn audit` + `yarn outdated`
- bun: `bun audit`

## Workflow

1. Detect package manager
2. Run audit and outdated check in parallel
3. Report critical vulnerabilities with CVE + fix command (see [severity-levels.md](references/severity-levels.md))
4. List outdated packages: table of package/current/latest/type (major vs minor/patch)
5. Check for unused deps: grep imports in `src/`

## Rules

- Never use `npx`/`bunx` directly
- Focus on actionable items
- Prioritize: security > major updates > unused > minor updates
