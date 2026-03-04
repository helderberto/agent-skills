---
name: e2e
description: Write end-to-end tests for user flows. Use when user asks to "write e2e tests", "/e2e", "add Playwright tests", "add Cypress tests", or wants to test a user flow end-to-end.
compatibility: Requires Playwright or Cypress installed and configured.
allowed-tools: Read Glob Grep Write
---

# End-to-End Tests

## Detection

Read `package.json` devDependencies:
- `@playwright/test` → Playwright (preferred)
- `cypress` → Cypress

Read existing test files to match project conventions.

## Workflow

1. Detect framework and read existing e2e tests (1-2 files)
2. Understand the user flow to test — ask if unclear
3. Identify selectors strategy (see [selectors.md](references/selectors.md))
4. Write tests matching existing style:
   - File location: `e2e/`, `tests/e2e/`, or `cypress/e2e/`
   - One file per flow or feature

## Playwright format

```typescript
import { test, expect } from '@playwright/test'

test('user can log in', async ({ page }) => {
  await page.goto('/login')
  await page.getByLabel('Email').fill('user@example.com')
  await page.getByLabel('Password').fill('password')
  await page.getByRole('button', { name: 'Sign in' }).click()
  await expect(page).toHaveURL('/dashboard')
})
```

## Cypress format

```typescript
describe('login flow', () => {
  it('user can log in', () => {
    cy.visit('/login')
    cy.findByLabelText('Email').type('user@example.com')
    cy.findByLabelText('Password').type('password')
    cy.findByRole('button', { name: 'Sign in' }).click()
    cy.url().should('include', '/dashboard')
  })
})
```

## Rules

- Prefer accessible selectors: `getByRole`, `getByLabel`, `getByText`
- Use `data-testid` only as last resort (see [selectors.md](references/selectors.md))
- One assertion per logical outcome — not one assertion per test
- Test behavior, not implementation
