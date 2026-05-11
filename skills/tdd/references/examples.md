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
it('valid credentials return user', () => {
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
it('invalid credentials return error', () => {
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

### WRONG — Horizontal Slices
```typescript
// Write all tests first (RED phase)
it('add item to cart')
it('remove item from cart')
it('calculate total')
it('apply discount')
it('checkout')

// Then write all implementation (GREEN phase)
// This produces bad tests - you're testing imagined behavior
```

### RIGHT — Vertical Slices
```typescript
// Test 1 → Implementation 1
it('add item to cart', () => { ... })
function addItem() { ... }

// Test 2 → Implementation 2
it('remove item from cart', () => { ... })
function removeItem() { ... }

// Each cycle learns from previous implementation
```

## Example 3: Good vs Bad Tests

### Good — Tests Public Behavior
```typescript
it('user can add item to cart', () => {
  const cart = new ShoppingCart()
  cart.addItem({ id: 1, name: 'Book', price: 10 })

  expect(cart.getTotal()).toBe(10)
  expect(cart.getItemCount()).toBe(1)
})
```

### Bad — Tests Implementation
```typescript
it('cart items array contains item', () => {
  const cart = new ShoppingCart()
  cart.addItem({ id: 1, name: 'Book', price: 10 })

  // Accessing private internals
  expect(cart._items).toHaveLength(1)
  expect(cart._items[0].id).toBe(1)
})
```

## Example 4: Verify Through Interface, Not External State

```typescript
// BAD: bypasses interface to verify
it('createUser saves to database', async () => {
  await createUser({ name: 'Alice' })
  const row = await db.query('SELECT * FROM users WHERE name = ?', ['Alice'])
  expect(row).toBeDefined()
})

// GOOD: verifies through interface
it('createUser makes user retrievable', async () => {
  const user = await createUser({ name: 'Alice' })
  const retrieved = await getUser(user.id)
  expect(retrieved.name).toBe('Alice')
})
```
