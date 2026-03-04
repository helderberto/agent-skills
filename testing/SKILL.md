---
name: testing
description: Run test suite and report results. Use when user asks to "run tests", "/test", "/testing", "execute tests", or requests running the test suite.
---

# Testing

## Package manager detection

Check lockfile: `bun.lock` → bun, `pnpm-lock.yaml` → pnpm, `yarn.lock` → yarn, else npm.

## Commands

| Script | Command |
|---|---|
| run | `{pm} test` |
| watch | `{pm} run test:watch` |
| ci+coverage | `{pm} run test:ci` |

For bun: `bun test` (no package.json scripts needed).

## Workflow

1. Detect package manager from lockfile
2. Run `{pm} test`
3. Report results concisely: show failing test names and file paths

## Rules

- Default to `{pm} test`
- Don't modify tests unless requested
