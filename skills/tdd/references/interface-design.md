# Interface Design for Testability

Good interfaces make testing natural.

## 1. Accept Dependencies, Don't Create Them

```typescript
// Testable — dependency injected
function processOrder(order, paymentGateway) {}

// Hard to test — creates its own dependency
function processOrder(order) {
  const gateway = new StripeGateway()
}
```

## 2. Return Results, Don't Produce Side Effects

```typescript
// Testable — returns a value to assert on
function calculateDiscount(cart): Discount {}

// Hard to test — mutates in place
function applyDiscount(cart): void {
  cart.total -= discount
}
```

## 3. Small Surface Area

- Fewer methods = fewer tests needed
- Fewer params = simpler test setup
- See [deep-modules.md](deep-modules.md) for the theory
