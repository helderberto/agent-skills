---
name: tdd
description: Guides test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants test-first development, or requests TDD workflow. Don't use for writing tests after implementation, adding tests to existing untested code, or one-off test fixes.
compatibility: Requires a configured test runner (jest or vitest)
allowed-tools: Bash Read Glob Grep Write
---

# Test-Driven Development

## Philosophy

Tests verify behavior through public interfaces, not implementation. Good tests survive refactors.

See [principles.md](references/principles.md) for testing philosophy and anti-patterns.

## Workflow

### 1. Planning
- Confirm interface design with user
- List behaviors to test (prioritize critical paths)
- Get approval before writing code

### 2. Tracer Bullet
```
RED:   Write first test → fails
GREEN: Minimal code to pass → passes
```

### 3. Incremental Loop
For each remaining behavior:
```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:
- One test at a time
- Minimal code to pass
- No refactoring while RED

### 4. Refactor
Once all tests GREEN:
- Remove duplication
- Improve structure
- Tests must stay GREEN

## Anti-Pattern: Horizontal Slices

**DO NOT** write all tests first, then all implementation.
**DO** use vertical slices: one test → one implementation → repeat.

See [examples.md](references/examples.md) for workflow demonstrations.

## Error Handling

- If test runner is not found → check `package.json` for `test` script; ask user which runner to use
- If tests go RED after refactor → revert the refactor immediately and re-attempt in smaller steps
- If a test cannot be made GREEN with minimal code → revisit the interface design with the user before continuing
