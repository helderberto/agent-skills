# TDD Principles

## Good vs Bad Tests

### Good Tests
- Test behavior through public interfaces
- Describe WHAT the system does, not HOW
- Read like specifications: "user can checkout with valid cart"
- Survive refactors (internal changes don't break them)
- Integration-style: exercise real code paths

### Bad Tests
- Coupled to implementation details
- Test private methods or internal state
- Mock internal collaborators excessively
- Break when you refactor but behavior hasn't changed
- Warning sign: test fails after renaming internal function

## Core Principle

**"Tests should verify behavior through public interfaces, not implementation details."**

If you rename an internal function and tests fail, those tests were testing implementation, not behavior.

## Testing Strategy

**You can't test everything.** Focus on:
- Critical paths
- Complex logic
- Edge cases that matter
- User-facing behavior

Skip testing:
- Trivial getters/setters
- Framework code
- Third-party libraries
- Every possible permutation

## Mocking Guidelines

Mock external dependencies (APIs, databases, file system).
Don't mock your own code (test real integration).

Good mocks:
- External API calls
- Database connections
- File I/O
- Time/dates
- Random number generation

Bad mocks:
- Your own classes/functions
- Simple utilities
- Internal collaborators
