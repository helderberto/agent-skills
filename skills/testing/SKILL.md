---
name: testing
description: Run the test suite and report results. Use when user asks to "run tests", "/test", "/testing", "execute tests", or requests running the test suite. Don't use for writing new tests (use `tdd`), checking coverage (use `coverage`), validating lint + types + tests together (use `validate-code`), or running a single specific test file.
---

# Testing

Simple wrapper that runs `npm test` and reports the result concisely. For wider validation (lint + types + tests), use `validate-code`. For coverage analysis, use `coverage`.

## Commands

| Script         | Command              |
| -------------- | -------------------- |
| run            | `npm test`           |
| watch          | `npm run test:watch` |
| ci + coverage  | `npm run test:ci`    |

## Workflow

1. Run `npm test`
2. Report results concisely: show failing test names and their file paths
3. Stop — do not modify tests, do not commit, do not push

## Rules

- Default to `npm test`
- Don't modify tests unless the user explicitly asks
- Don't run extra checks (lint, typecheck, build) — that's `validate-code`'s job
- Don't compute coverage — that's `coverage`'s job

## Error Handling

- If `npm test` script not found → check `package.json` scripts for alternatives (`jest`, `vitest`, `test:run`); report if none exist
- If tests time out → report the timeout and suggest increasing `--testTimeout` in the runner config
- If test runner crashes (exit code other than 0 or 1) → report the crash output and stop
