# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```typescript
// Easy to mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific functions for each external operation instead of one generic function with conditional logic:

```typescript
// GOOD: Each function is independently mockable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch("/orders", { method: "POST", body: data }),
};

// BAD: Mocking requires conditional logic inside the mock
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

The SDK approach means:

- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint

## React Testing Library

- Use `userEvent` (via `@testing-library/user-event`) instead of `fireEvent` — it simulates real browser interactions
- Prefer `vi.spyOn` over `vi.mock(` when mocking your own code — less invasive and auto-restorable
- Only use `vi.mock(` when mocking a library or external module behavior
- Stub browser globals (`navigator`, `matchMedia`, `fetch`, `localStorage`) with `vi.stubGlobal`, not `Object.defineProperty` or `vi.spyOn` on `window`; `unstubGlobals` in the config restores them after each test
- Query by role and accessible name first, then label, then visible text; a test id only when no accessible handle exists. The same order holds in end-to-end tests ([ui-tests.md](ui-tests.md))
