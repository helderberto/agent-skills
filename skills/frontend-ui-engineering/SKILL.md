---
name: frontend-ui-engineering
effort: high
description: Front-load UI construction decisions — component boundary and prop API, where state lives, data/async, the required UI states (loading/empty/error), responsive behavior, and accessibility by construction. Use when creating or refactoring a component, page, or design-system primitive. Don't use for pure logic (tdd), throwaway direction exploration (prototype), generic module design (codebase-design), or auditing finished UI (a11y-audit/perf-audit/visual-validate).
argument-hint: '[component or path]'
---

# Frontend UI Engineering

Decide **how to structure a UI unit before writing it**, so the choices your audits would otherwise catch late (accessibility, i18n, bundle cost, missing states) are made up front. This is the frontend counterpart to [`codebase-design`](../codebase-design/SKILL.md): treat a component as a **deep module** — a lot of behaviour behind a small prop surface.

It is a **knowledge/decision skill**, not a code generator. It resolves the design questions, then hands the actual implementation to `tdd`/`build` and verification to the audit skills. Framework-agnostic; examples in React.

Boundaries:

- vs `tdd` / `build` — they implement; this decides the UI shape and hands off.
- vs `codebase-design` — that is generic module depth; this applies the lens to components (prop surface = public API).
- vs `prototype` — that explores throwaway directions; this is for code that stays.
- vs `a11y-audit` / `i18n` / `perf-audit` / `visual-validate` — they verify after; this builds it right up front. It **references** their standards, never re-copies their checklists.

## Workflow

### Phase 1 — Classify the work

Name the unit and pick the emphasis:

| Kind | Emphasis |
|------|----------|
| Design-system primitive (Button, Input) | prop API, variants via props, tokens, a11y contract |
| Composite component | composition, state placement, the required states |
| Page / route | data fetching boundary, layout, loading/error at the route |
| Refactor of existing UI | shrink prop surface, extract states, remove magic values |

### Phase 2 — Decision pass (resolve before coding)

Work through each; state the decision explicitly.

1. **Boundary & prop API.** Smallest surface that serves callers. Prefer **composition** (`children`/slots) over configuration. A growing set of boolean flags (`isPrimary`, `isSmall`, `isLoading`…) is a smell — reach for a `variant`/`size` union or composition instead.
2. **Where state lives.** The lowest owner that still works: local → lifted to parent → server state → URL. No derived state stored twice; compute from source.
3. **Data & async.** Decide where data is fetched (route/loader boundary vs. inside the component) and who owns caching. Keep components that render data separate from components that fetch it where practical.
4. **Required UI states.** Enumerate and design them now, not later: **loading, empty, error, disabled**, and partial/optimistic where relevant. A component that only handles the happy path is unfinished.
5. **Styling.** Use design-system **tokens** (no magic colors/spacing). Express variants through props, not one-off class overrides.
6. **Responsive / adaptive.** Mobile-first; intentional breakpoints; no fixed widths that break small screens.
7. **Accessibility by construction.** Semantic HTML first, ARIA only as a last resort; keyboard + focus order; a label for every control; visible focus. (Defers to [`a11y-audit`](../a11y-audit/SKILL.md) for the full WCAG pass.)
8. **User-facing strings.** Route them through the project's i18n path from the start rather than hardcoding. (Defers to [`i18n`](../i18n/SKILL.md).)

### Phase 3 — Build

Apply the decisions. Keep the component shallow at its interface and hide implementation detail behind it. Delegate any non-trivial logic to `tdd` (red → green → refactor); this skill does not hand-write the whole component or its tests.

### Phase 4 — Definition of done + handoff

Do not consider the unit done until:

- [ ] Prop surface is minimal; no boolean-flag proliferation
- [ ] Loading, empty, error, and disabled states exist
- [ ] Keyboard reachable and operable; semantic elements used
- [ ] Styling uses tokens; responsive down to the smallest target
- [ ] User-facing strings are translatable

Then hand off: **`tdd`** for behavior tests (query by role/label), **`visual-validate`** for before/after in a real browser, and let **`review`** run the audits (a11y/i18n/perf) as the final gate.

## Rules

- Resolve the Phase 2 decisions explicitly before writing the component — state each choice.
- Reference the audit skills' standards; never duplicate their checklists here.
- Never hand-write full tests — that is `tdd`. This skill designs; it does not replace the builders.
- Framework-agnostic; do not assume a specific framework unless the codebase already uses one.
- Stay within the current unit — do not redesign unrelated components.

## Anti-rationalization

Excuses that skip the work, and the rebuttal:

| Excuse | Rebuttal |
|--------|----------|
| "I'll add the error/empty state later." | Later never comes and it ships half-built. States are part of the design pass, not a follow-up. |
| "A boolean prop is faster right now." | Three booleans is eight states, most untested. A `variant` union or composition is cheaper within a week. |
| "Hardcode the string, I'll translate later." | Retro-i18n means re-touching every component. Route it now — it's one import. |
| "ARIA will fix the accessibility." | Semantic HTML gives it for free; ARIA is the patch for when you couldn't. Reach for the element first. |
| "Fetch inside the component, it's simpler." | It couples render to network and blocks reuse/testing. Decide the fetch boundary deliberately. |

## Red flags

- A prop list longer than the component's own logic.
- `any`/loose props at the component boundary.
- Only the happy path rendered.
- Magic color/spacing values instead of tokens.
- `div`/`span` with click handlers instead of a `button`/`a`.
