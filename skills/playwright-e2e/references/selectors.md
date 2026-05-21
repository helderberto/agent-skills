# Playwright Selector Best Practices

## Selector Priority

1. `page.getByRole('button', { name: 'Submit' })` — best for accessible UI
2. `page.getByLabel('Email')` — for form fields
3. `page.getByText('Welcome')` — for visible text
4. `page.locator('[data-testid="submit"]')` — last resort, only if no semantic selector works

## Examples

```typescript
// By role (preferred)
await page.getByRole('button', { name: 'Sign in' }).click();

// By label
await page.getByLabel('Email').fill('user@example.com');

// By text
await page.getByText('Welcome').isVisible();

// By test id (last resort)
await page.locator('[data-testid="submit"]');
```

## Rules
- Prefer semantic selectors for maintainability and resilience
- Use Playwright Testing Library selectors when possible
- Only use `data-testid` if no semantic selector is available
- Never use brittle selectors like `.class` or `#id` unless they are stable and documented
- Avoid XPath selectors

## References
- [Playwright Testing Library Docs](https://playwright.dev/docs/test-assertions#locators)
- [ARIA roles guide](https://www.w3.org/TR/wai-aria-1.1/#roles)
- [Accessible selectors](https://playwright.dev/docs/accessibility-testing)
