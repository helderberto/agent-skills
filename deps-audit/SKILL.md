---
name: deps-audit
description: Check dependencies for vulnerabilities. Use when user asks to "audit dependencies", "/deps-audit", "check for vulnerabilities", or wants to check dependency health. Don't use for yarn, pnpm, or bun projects (npm only), or for reviewing code quality.
---

# Dependency Audit

## Commands

Run in parallel:
- `npm audit`
- `npm outdated`

## Workflow

1. Run audit and outdated check in parallel
2. Report vulnerabilities with CVE + fix command using severity table below
3. List outdated packages: table of package/current/latest/type (major vs minor/patch)
4. Check for unused deps: grep imports in `src/`

## Severity Levels

| Level | CVSS | Action |
|---|---|---|
| **Critical** | 9.0-10.0 | Fix immediately, block merge |
| **High** | 7.0-8.9 | Fix before next release |
| **Moderate** | 4.0-6.9 | Fix in current sprint |
| **Low** | 0.1-3.9 | Fix when convenient |

For each critical/high vulnerability report:
```
Package: <name>@<version>
CVE: CVE-YYYY-XXXXX
Severity: Critical
Description: <one line>
Fix: npm audit fix --force  (or: npm install <pkg>@<safe-version>)
```

## Rules

- Never use `npx` directly
- Focus on actionable items
- Prioritize: security > major updates > unused > minor updates

## Error Handling

- `npm audit` fails -- run `npm install` first to generate `package-lock.json`, then retry
- `npm outdated` returns nothing -- report all dependencies are current
- `npm` not found -- report incompatibility; this skill requires npm
