---
name: testing
description: Run test suite and report results. Use when user asks to "run tests", "/test", "/testing", "execute tests", or requests running the test suite. Don't use for writing new tests, checking coverage, or running a single specific test file.
compatibility: Requires npm with a test script
allowed-tools: Bash(npm:*) Read Glob
---

# Testing

## Commands

| Script | Command |
|---|---|
| run | `npm test` |
| watch | `npm run test:watch` |
| ci+coverage | `npm run test:ci` |

## Workflow

1. Run `npm test`
2. Report results concisely: show failing test names and file paths

## Rules

- Default to `npm test`
- Don't modify tests unless requested

## Error Handling

- If `npm test` script not found → check `package.json` scripts for alternatives (`jest`, `vitest`, `test:run`); report if none exist
- If tests time out → report the timeout and suggest increasing `--testTimeout` in the runner config
- If test runner crashes (exit code other than 0 or 1) → report the crash output and stop
