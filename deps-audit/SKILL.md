---
name: deps-audit
description: Check dependencies for vulnerabilities. Use when user asks to "audit dependencies", "/deps-audit", "check for vulnerabilities", or wants to check dependency health. Don't use for yarn, pnpm, or bun projects (npm only), or for reviewing code quality.
disable-model-invocation: true
compatibility: Requires npm
allowed-tools: Bash(npm:*) Read Grep Glob
---

# Dependency Audit

## Commands

Run in parallel:
- `npm audit`
- `npm outdated`

## Workflow

1. Run audit and outdated check in parallel
2. Report critical vulnerabilities with CVE + fix command (see [severity-levels.md](references/severity-levels.md))
3. List outdated packages: table of package/current/latest/type (major vs minor/patch)
4. Check for unused deps: grep imports in `src/`

## Rules

- Never use `npx` directly
- Focus on actionable items
- Prioritize: security > major updates > unused > minor updates

## Error Handling

- If `npm audit` fails → run `npm install` first to generate `package-lock.json`, then retry
- If `npm outdated` returns nothing → report all dependencies are current
- If `npm` is not found → report incompatibility; this skill requires npm
