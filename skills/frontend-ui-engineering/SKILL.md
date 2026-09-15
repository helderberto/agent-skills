---
name: frontend-ui-engineering
effort: high
description: Front-load UI construction decisions — component boundary and prop API, state placement, required states, responsiveness, accessibility. Use when creating or refactoring a component, page, or design-system primitive. Don't use for pure logic (/tdd), throwaway exploration (/prototype), or auditing finished UI (/a11y-audit).
argument-hint: '[component or path]'
---

# Frontend UI Engineering

Decide **how to structure a UI unit before writing it**, so the choices audits would catch late (accessibility, i18n, bundle cost, missing states) are made up front. Frontend counterpart to [`codebase-design`](../codebase-design/SKILL.md): a component is a **deep module** — a lot of behaviour behind a small prop surface. This skill decides; `tdd`/`build` implement; the audit skills verify. Framework-agnostic.

## 1. Classify the unit

| Kind | Emphasis |
|------|----------|
| Design-system primitive (Button, Input) | prop API, variants via props, tokens, a11y contract |
| Composite component | composition, state placement, required states |
| Page / route | data-fetching boundary, layout, loading/error at the route |
| Refactor of existing UI | shrink prop surface, extract states, remove magic values |

## 2. Decision pass — state each choice before coding

1. **Boundary & prop API.** Smallest surface that serves callers. Prefer **composition** (`children`/slots) over configuration. A growing set of boolean flags (`isPrimary`, `isSmall`, `isLoading`…) is a smell — three booleans is eight states, most untested; reach for a `variant`/`size` union or composition.
2. **Where state lives.** The lowest owner that still works: local → lifted → server state → URL. No derived state stored twice; compute from source.
3. **Data & async.** Decide the fetch boundary (route/loader vs. inside the component) and who owns caching. Keep rendering components separate from fetching ones where practical.
4. **Required UI states.** Enumerate and design **loading, empty, error, disabled** (and partial/optimistic where relevant) now. Happy-path-only is unfinished.
5. **Styling.** Design-system **tokens**, no magic colors/spacing. Variants through props, not one-off overrides.
6. **Responsive.** Mobile-first; intentional breakpoints; no fixed widths that break small screens.
7. **Accessibility by construction.** Semantic HTML first, ARIA last; keyboard + focus order; a label for every control; visible focus. Full WCAG pass belongs to [`a11y-audit`](../a11y-audit/SKILL.md).
8. **User-facing strings.** Through the project's i18n path from the start. Coverage check belongs to [`i18n`](../i18n/SKILL.md).

## 3. Build and hand off

Apply the decisions; delegate non-trivial logic and its tests to `tdd`. Then `visual-validate` for before/after in a real browser, and `review` runs the audits as the final gate.
