# UI Tests

End-to-end tests drive user flows through the real UI. Shared by `tdd`, `refactor`, and `visual-review`.

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
