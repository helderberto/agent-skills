# TDD Examples

## Example 1: User Authentication

### Planning
Behaviors to test:
1. Valid credentials return user
2. Invalid credentials return error
3. Expired session rejected

### Tracer Bullet
```typescript
// RED
test('valid credentials return user', () => {
  const result = authenticate('user@test.com', 'pass123')
  expect(result).toEqual({ email: 'user@test.com' })
})

// GREEN - minimal implementation
function authenticate(email: string, password: string) {
  return { email }
}
```

### Incremental Loop
```typescript
// RED
test('invalid credentials return error', () => {
  const result = authenticate('user@test.com', 'wrong')
  expect(result).toEqual({ error: 'Invalid credentials' })
})

// GREEN
function authenticate(email: string, password: string) {
  if (password !== 'pass123') {
    return { error: 'Invalid credentials' }
  }
  return { email }
}
```

### Refactor
```typescript
// All tests GREEN - now refactor
function authenticate(email: string, password: string) {
  const validPassword = verifyPassword(password)
  if (!validPassword) {
    return { error: 'Invalid credentials' }
  }
  return { email }
}
```

## Example 2: Horizontal vs Vertical

### WRONG - Horizontal Slices
```typescript
// Write all tests first (RED phase)
test('add item to cart')
test('remove item from cart')
test('calculate total')
test('apply discount')
test('checkout')

// Then write all implementation (GREEN phase)
// This produces bad tests - you're testing imagined behavior
```

### RIGHT - Vertical Slices
```typescript
// Test 1 → Implementation 1
test('add item to cart', () => { ... })
function addItem() { ... }

// Test 2 → Implementation 2
test('remove item from cart', () => { ... })
function removeItem() { ... }

// Each cycle learns from previous implementation
```

## Example 3: Testing Public Interface

### Good - Tests Public Behavior
```typescript
test('user can add item to cart', () => {
  const cart = new ShoppingCart()
  cart.addItem({ id: 1, name: 'Book', price: 10 })

  expect(cart.getTotal()).toBe(10)
  expect(cart.getItemCount()).toBe(1)
})
```

### Bad - Tests Implementation
```typescript
test('cart items array contains item', () => {
  const cart = new ShoppingCart()
  cart.addItem({ id: 1, name: 'Book', price: 10 })

  // Accessing private internals
  expect(cart._items).toHaveLength(1)
  expect(cart._items[0].id).toBe(1)
})
```
