---
name: deps-audit
description: Check dependencies for known vulnerabilities and staleness. Use when user asks to "audit dependencies", "/deps-audit", "check for vulnerabilities", or wants to check dependency health. Don't use for reviewing code quality.
---

# Dependency Audit

Detect the project's package manager from its lockfile and run that ecosystem's audit + outdated tooling. Don't assume npm.

## Detection

| Ecosystem | Lockfile | Audit | Outdated |
|---|---|---|---|
| npm | `package-lock.json` | `npm audit` | `npm outdated` |
| pnpm | `pnpm-lock.yaml` | `pnpm audit` | `pnpm outdated` |
| yarn | `yarn.lock` | `yarn npm audit` (berry) / `yarn audit` | `yarn outdated` |
| Python | `requirements*.txt` / `uv.lock` / `poetry.lock` | `pip-audit` | `pip list --outdated` |
| Go | `go.sum` | `govulncheck ./...` | `go list -m -u all` |
| Rust | `Cargo.lock` | `cargo audit` | `cargo outdated` |

## Workflow

1. Detect the ecosystem from the lockfile; run audit + outdated (parallel where possible)
2. Report vulnerabilities with advisory ID + fix command using the severity table below
3. List outdated packages: table of package/current/latest/type (major vs minor/patch)
4. Check for obviously unused deps: grep imports in the source dir

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
Advisory: <CVE / GHSA / RUSTSEC id>
Severity: Critical
Description: <one line>
Fix: <ecosystem fix command, e.g. npm audit fix / cargo update -p <pkg>>
```

## Rules

- Detect the package manager from the lockfile — never assume npm
- Prefer the project's own audit task if it defines one
- Focus on actionable items
- Prioritize: security > major updates > unused > minor updates

## Error Handling

- Audit tool missing for the ecosystem → report which tool to install (e.g. `pip-audit`, `govulncheck`, `cargo-audit`) and stop
- Audit fails for a missing lockfile → generate it (install), then retry
- Outdated returns nothing → report all dependencies are current
