---
name: ci-cd
description: Set up or modify CI/CD pipelines for automated quality gates and deployment. Use when scaffolding a new project's pipeline, adding checks (lint, types, tests, build, audit), configuring deployment, or debugging CI failures. Don't use for local pre-commit hooks (use `setup-pre-commit`) or for one-off script runs.
---

# CI/CD

Automate quality gates so no change reaches production without passing tests, lint, type checking, and build. CI is the enforcement mechanism for every other skill — it catches what humans and agents miss, consistently, on every change.

**Shift left**: catch problems as early as possible. A bug caught in lint costs minutes; the same bug in production costs hours. Move checks upstream — static analysis before tests, tests before staging, staging before production.

**Faster is safer**: smaller batches, more frequent releases. A deployment with 3 changes is easier to debug than one with 30.

## When to Use

- Setting up a new project's CI pipeline
- Adding or modifying automated checks
- Configuring deployment pipelines
- When a change should trigger automated verification
- Debugging CI failures

## The Quality Gate Pipeline

Every PR passes these gates before merge:

```
PR opened
  │
  ▼
LINT          eslint, prettier (or language equivalents)
  │ pass
  ▼
TYPECHECK     tsc --noEmit (or equivalent)
  │ pass
  ▼
UNIT TESTS    jest/vitest/pytest
  │ pass
  ▼
BUILD         npm run build (catches build-time errors lint misses)
  │ pass
  ▼
INTEGRATION   API + DB tests (if applicable)
  │ pass
  ▼
E2E (opt)     Playwright/Cypress (slowest, run on main paths only)
  │ pass
  ▼
SECURITY      deps-audit / npm audit
  │ pass
  ▼
BUNDLE SIZE   bundlesize check (frontend projects)
  │ pass
  ▼
MERGE OK
```

Each gate is independent and parallel where possible. Fail-fast: stop the pipeline on the first failure, but report all results when running parallel jobs.

## Platform mapping

| Use case | Platform | Notes |
|----------|----------|-------|
| Open source / personal projects | GitHub Actions | Free for public repos; fast onboarding |
| Work projects with self-hosted infra | Buildkite | Hybrid hosted/self-hosted agents; better for monorepos |
| GitLab projects | GitLab CI | Native integration with merge requests |
| Multi-cloud / vendor-neutral | CircleCI, Drone | Less common in 2026 |

This skill assumes GitHub Actions for personal projects and Buildkite for work projects. Other platforms have equivalent concepts.

## GitHub Actions starter

For a typical Node/TS project, a single `.github/workflows/ci.yml`:

```yaml
name: CI
on:
  pull_request:
  push:
    branches: [main]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: '.tool-versions'
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test -- --coverage
      - run: npm run build
      - run: npm audit --audit-level=high
```

Match the gates to what `validate-code` runs locally. Parity between local and CI is the goal — fewer "works on my machine" moments.

## Buildkite starter

For a work project with self-hosted agents:

```yaml
steps:
  - label: ":lint:"
    command: npm run lint
  - label: ":typescript:"
    command: npm run typecheck
  - label: ":test_tube:"
    command: npm test -- --coverage
  - label: ":hammer:"
    command: npm run build
  - wait
  - label: ":shipit:"
    branches: main
    command: ./scripts/deploy.sh
```

Use parallel steps for lint/typecheck/tests, then `wait` before deploy.

## Caching

Cache aggressively — caching is the cheapest CI optimization:

- `node_modules` — keyed by `package-lock.json` hash
- Build artifacts between jobs — pass via `actions/upload-artifact` or Buildkite artifacts
- Test results for affected-tests-only runs (Turbo, Nx, custom)

Bad cache > no cache: validate cache keys include all inputs (lock file + Node version + OS).

## Deployment strategies

| Strategy | When |
|----------|------|
| Blue/green | Zero-downtime releases, easy rollback (cost: 2x infra during deploy) |
| Canary | Gradual rollout, observe metrics, abort if regression |
| Rolling | Default for most apps, slow incremental replacement |
| Feature flags | Decouple deploy from release; ship dark, enable later |

For solo / small projects: simple rolling deploy + feature flags is usually enough.

## Rules

- Lint, typecheck, tests, build, security audit — all required to merge
- Local validation (`validate-code`) must match CI gates — no "passes locally, fails in CI"
- Fail fast on the first error in critical paths; run independent gates in parallel
- Cache dependencies aggressively; invalidate carefully (lock file + Node version + OS in key)
- Never auto-merge without all gates passing
- Never disable a gate to ship faster — fix the underlying issue or quarantine the test
- Deployments are atomic and reversible — every release has a rollback path

## Debugging CI failures

Process:

1. Reproduce locally if possible (`validate-code` matches CI gates)
2. Read the failing step's logs end-to-end — don't skim
3. Compare against the last passing run for the same gate (CI logs preserve history)
4. Hypothesize: env difference, race condition, flaky test, dep update
5. Fix or quarantine — never skip silently
6. Add a regression test if the failure was a real bug

## Red flags

- Same test fails intermittently — flaky test, quarantine and fix root cause
- CI passes but production breaks — gates don't reflect production constraints
- Long CI runs (>15min) — split, parallelize, cache
- Builds rerun from scratch every time — caching not configured
- Auto-merge enabled with weak gates — recipe for regressions
- "Skip CI" used routinely — gates too painful or too noisy; fix the gates

## Verification

After setting up or modifying a pipeline:

- [ ] All gates from the local `validate-code` skill are present in CI
- [ ] Average run time < 10 minutes for typical PR
- [ ] Caching cuts cold-start vs warm-start by >50%
- [ ] Failed gates produce actionable error messages with file:line refs
- [ ] Rollback path documented and tested
