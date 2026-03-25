---
name: tdd
description: Guides test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants test-first development, or requests TDD workflow. Don't use for writing tests after implementation, adding tests to existing untested code, or one-off test fixes.
compatibility: Requires a configured test runner (jest or vitest)
allowed-tools: Bash Read Glob Grep Write
---

# Test-Driven Development

## Philosophy

**Core principle**: Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't.

**Good tests** are integration-style: they exercise real code paths through public APIs. They describe _what_ the system does, not _how_. A good test reads like a spec — "user can checkout with valid cart" tells you exactly what capability exists. These tests survive refactors because they don't care about internal structure.

**Bad tests** are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means. Warning sign: test breaks when you refactor but behavior hasn't changed.

See [tests.md](references/tests.md) for examples and [mocking.md](references/mocking.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**DO NOT write all tests first, then all implementation.** This treats RED as "write all tests" and GREEN as "write all code."

This produces bad tests — written in bulk they test _imagined_ behavior, not _actual_ behavior. You commit to test structure before understanding the implementation.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

Each test responds to what you learned from the previous cycle.

See [examples.md](references/examples.md) for workflow demonstrations.

## Workflow

### 1. Planning

Before writing any code:

- [ ] Confirm interface design with user
- [ ] Identify opportunities for [deep modules](references/deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](references/interface-design.md)
- [ ] List behaviors to test (prioritize critical paths, not every edge case)
- [ ] Get user approval before writing code

Ask: "What should the public interface look like? Which behaviors are most important to test?"

### 2. Tracer Bullet

```
RED:   Write first test → fails
GREEN: Minimal code to pass → passes
```

Proves the path works end-to-end.

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
- Don't anticipate future tests

### 4. Refactor

Once all tests GREEN, look for [refactor candidates](references/refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.**

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```

## Error Handling

- If test runner not found → check `package.json` for `test` script; ask user which runner to use
- If tests go RED after refactor → revert immediately and re-attempt in smaller steps
- If a test cannot be made GREEN with minimal code → revisit the interface design with the user
