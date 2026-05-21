---
name: playwright-e2e
description: Write end-to-end regression tests for user flows using Playwright. Use when user asks to "write Playwright tests", "/e2e", "add Playwright regression tests", or wants to test a user flow end-to-end with Playwright. Don't use for unit/component tests or non-Playwright frameworks.
---

# End-to-End Regression Tests (Playwright)

## Detection

Run in parallel:
- Check `package.json` for `@playwright/test` version
- Read `playwright.config.ts` for baseURL and testDir
- Read 1-2 existing test files in `tests/` or `e2e/` to match conventions

## Workflow

1. Read existing tests and config to match project style
2. Understand the user flow — ask if unclear
3. Identify selectors (see [selectors.md](references/selectors.md) if present)
4. Write tests in `tests/` or `e2e/` — one file per flow or feature

## Format

```typescript
test.describe('login flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
  });

  test('logs in with valid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('user@example.com');
    await page.getByLabel('Password').fill('password');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page).toHaveURL(/.*dashboard/);
    await expect(page.getByRole('heading', { name: 'Dashboard' })).toBeVisible();
  });

  test('shows error with invalid credentials', async ({ page }) => {
    await page.getByLabel('Email').fill('wrong@example.com');
    await page.getByLabel('Password').fill('wrong');
    await page.getByRole('button', { name: 'Sign in' }).click();
    await expect(page.getByRole('alert')).toContainText('Invalid credentials');
  });
});
```

## Selector priority

Prefer Playwright Testing Library selectors when available:

1. `page.getByRole('button', { name: 'Submit' })` — best
2. `page.getByLabel('Email')` — forms
3. `page.getByText('Welcome')` — text content
4. `page.locator('[data-testid="submit"]')` — last resort

See [selectors.md](references/selectors.md) for full guide.

## Rules

- Use Playwright Testing Library selectors when available, else `page.locator`
- Use `data-testid` only as last resort
- One logical outcome per `test` block
- Test behavior, not implementation details
- Never use `page.waitForTimeout` — use auto-waiting selectors instead

## Error Handling

- If `@playwright/test` is not in `package.json` → stop and ask user to install Playwright first
- If `playwright.config.ts` is missing → ask user to run `npx playwright init` to initialize config
- If `baseURL` is unreachable → verify the dev server is running before writing tests that require it

## Completion Criteria

- Test covers all critical user flows for regression
- Follows project style and selector conventions
- Passes locally with `npx playwright test`
- Handles setup/teardown as needed
