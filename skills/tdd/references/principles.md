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

Red flags:
- Test fails after renaming an internal function
- Test name describes HOW not WHAT
- Asserting on call counts/order of internal methods
- Verifying through external means instead of the interface (e.g., querying DB directly)

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

Mock at **system boundaries** only. Don't mock your own code.

Good mocks:
- External API calls
- Database connections (sometimes — prefer a test DB)
- File I/O
- Time/dates
- Random number generation

Bad mocks:
- Your own classes/functions
- Simple utilities
- Internal collaborators

### SDK-Style Interfaces Over Generic Fetchers

At system boundaries, prefer specific functions over one generic function with conditional logic:

```typescript
// GOOD: each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
}

// BAD: mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
}
```

The SDK approach means each mock returns one specific shape, no conditional logic in test setup, and type safety per endpoint.

## React Testing Library

- Use `userEvent` (via `@testing-library/user-event`) instead of `fireEvent` — it simulates real browser interactions
- Prefer `vi.spyOn` over `vi.mock(` when mocking your own code — less invasive and auto-restorable
- Only use `vi.mock(` when mocking a library or external module behavior
