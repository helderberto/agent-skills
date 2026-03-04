# Selector Strategy for E2E Tests

## Priority order (most to least preferred)

### 1. Role + name (best)
Mirrors how assistive technologies see the page. Resilient to style changes.

```typescript
// Playwright
page.getByRole('button', { name: 'Submit' })
page.getByRole('textbox', { name: 'Email' })
page.getByRole('heading', { name: 'Sign in' })
page.getByRole('link', { name: 'Home' })

// Cypress + Testing Library
cy.findByRole('button', { name: 'Submit' })
```

### 2. Label (forms)

```typescript
// Playwright
page.getByLabel('Email address')

// Cypress
cy.findByLabelText('Email address')
```

### 3. Text content

```typescript
// Playwright
page.getByText('Welcome back')

// Cypress
cy.findByText('Welcome back')
```

### 4. Placeholder

```typescript
page.getByPlaceholder('Search...')
```

### 5. `data-testid` (last resort)
Use when there's no accessible label and adding one isn't feasible.

```typescript
// Playwright
page.getByTestId('submit-button')

// Renders as:
<button data-testid="submit-button">Submit</button>
```

**Avoid**: CSS classes, IDs tied to styling, XPath, nth-child selectors.

## Why avoid CSS selectors?

```typescript
// Fragile — breaks on refactor
page.locator('.btn-primary')
page.locator('#submit')
page.locator('form > div:nth-child(2) > input')

// Resilient — describes behavior, not structure
page.getByRole('button', { name: 'Submit' })
```

## Playwright cheat sheet

```typescript
// Navigation
await page.goto('/login')

// Filling forms
await page.getByLabel('Email').fill('user@example.com')
await page.getByLabel('Password').fill('secret')

// Clicking
await page.getByRole('button', { name: 'Sign in' }).click()

// Assertions
await expect(page).toHaveURL('/dashboard')
await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible()
await expect(page.getByText('Error')).not.toBeVisible()

// Waiting (Playwright auto-waits, but explicit when needed)
await page.waitForURL('/dashboard')
await expect(page.getByRole('status')).toHaveText('Saved')
```
