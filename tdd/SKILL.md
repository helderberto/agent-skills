---
name: tdd
description: Guides test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants test-first development, or requests TDD workflow. Don't use for writing tests after implementation, adding tests to existing untested code, or one-off test fixes.
compatibility: Requires a configured test runner (jest or vitest)
allowed-tools: Bash Read Glob Grep Write
---

# Test-Driven Development

Tests verify behavior through public interfaces, not implementation details. See [principles.md](references/principles.md) for testing philosophy and mocking guidelines.

**DO NOT write all tests first, then all implementation.** Each cycle: one test → minimal code to pass → next test. See [examples.md](references/examples.md) for demonstrations.

## Workflow

### 1. Planning

- [ ] Confirm interface design with user
- [ ] Identify opportunities for [deep modules](references/deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](references/interface-design.md)
- [ ] List behaviors to test (prioritize critical paths)
- [ ] Get user approval before writing code

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

One test at a time. Minimal code to pass. No refactoring while RED.

### 4. Refactor

Once all tests GREEN, look for [refactor candidates](references/refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Run tests after each refactor step

**Never refactor while RED.**

## Error Handling

- If test runner not found → check `package.json` for `test` script; ask user which runner to use
- If tests go RED after refactor → revert immediately and re-attempt in smaller steps
- If a test cannot be made GREEN with minimal code → revisit the interface design with the user
