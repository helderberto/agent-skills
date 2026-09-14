---
name: deps-audit
description: Check dependencies for known vulnerabilities and staleness. Use when user asks to "audit dependencies", "check for vulnerabilities", or wants to check dependency health. Don't use for reviewing code quality.
---

# Dependency Audit

Detect the package manager from its lockfile and run that ecosystem's audit + outdated tooling. Prefer the project's own audit task if it defines one. Never assume npm.

| Ecosystem | Lockfile | Audit | Outdated |
|---|---|---|---|
| npm | `package-lock.json` | `npm audit` | `npm outdated` |
| pnpm | `pnpm-lock.yaml` | `pnpm audit` | `pnpm outdated` |
| yarn | `yarn.lock` | `yarn npm audit` (berry) / `yarn audit` | `yarn outdated` |
| Python | `requirements*.txt` / `uv.lock` / `poetry.lock` | `pip-audit` | `pip list --outdated` |
| Go | `go.sum` | `govulncheck ./...` | `go list -m -u all` |
| Rust | `Cargo.lock` | `cargo audit` | `cargo outdated` |

Audit tool missing → say which to install and stop. Lockfile missing → install to generate it, then retry.

## Report

1. Vulnerabilities, critical/high first: package@version, advisory id (CVE/GHSA/RUSTSEC), one line, the ecosystem's fix command.
2. Outdated packages: package / current / latest / major vs minor.
3. Obviously unused deps (grep imports in the source dir).

Action by severity: critical → fix now, blocks merge; high → before next release; moderate → this sprint; low → when convenient. Then major updates > unused > minor.
