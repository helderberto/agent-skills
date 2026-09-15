---
name: e2e
description: Write end-to-end tests for user flows with the project's E2E framework (Playwright, Cypress, other). Use when asked to "write e2e tests", "add Playwright/Cypress tests", or test a user flow end-to-end. Don't use for unit or component tests (/tdd) or manual browser checks (/visual-validate).
---

# End-to-End Tests

## Detect the framework

Read the manifest and config (`playwright.config.*`, `cypress.config.*`, …) for the framework, base URL, and test location. Read 1–2 existing E2E tests and match their conventions. No E2E framework installed → stop and ask which to set up.

## Write the test

One file per flow or feature; one logical outcome per test. Understand the user flow first — ask if unclear. Test behavior through the UI, not implementation details.

**Selector priority**, most to least resilient:

1. Role + accessible name (`getByRole('button', { name: 'Submit' })`)
2. Label (form controls)
3. Visible text
4. Placeholder
5. `data-testid` — last resort, when no accessible handle exists

Never CSS classes, ids, or structural selectors — they break on refactor. Never fixed sleeps — use the framework's auto-waiting/retrying queries.
