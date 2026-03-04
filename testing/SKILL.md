---
name: testing
description: Run test suite and report results. Use when user asks to "run tests", "/test", "/testing", "execute tests", or requests running the test suite.
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
