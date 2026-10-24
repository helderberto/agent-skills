---
name: project-structure
description: Folder layout and file rules for TypeScript and React projects — `@` alias, barrels, features, views, hooks, types, lib wrappers, kebab-case, sibling tests, named exports. Use when scaffolding a project, adding a file, deciding where code goes, or splitting a large file. Don't use for a module's interface (/codebase-design) or a component's props (/frontend-ui-engineering).
user-invocable: false
---

# Project Structure

Every file has one obvious home, and every folder one way in. Apply this layout to new projects and new code. A repo with its own established layout keeps it: follow the repo, and propose a migration as its own change rather than moving files in passing.

## Layout

```
src/                      imported as @/…
├── components/           shared UI, exposed through index.ts
├── features/<feature>/   deep modules, entered only through index.ts
├── views/                screens that compose features and components
├── hooks/                hooks shared across features
├── types/                domain types and DTOs, one file per domain
└── lib/<library>/        a wrapper per third-party library the app imports
```

- **`@` alias.** Import across folders with `@/…`; `./` only within one folder. Map `@/*` to `src/*` in `tsconfig.json` and in the bundler and test-runner config, so all three resolve the same path.
- **`components/`** holds components used by two or more features. `components/index.ts` is the barrel: `import { Button } from '@/components'`. A component one feature uses lives in that feature.
- **`features/<feature>/`** is a deep module: a lot of behaviour behind a small interface. `index.ts` exports that interface and nothing else; callers import `@/features/<feature>`, never a file inside it. Call the Skill tool with `codebase-design` to decide what the interface hides.
- **`views/`** is thin: layout and composition. Logic found in a view moves into a feature. With file-based routing (Next.js `app/`, Remix `routes/`), a route file loads data, sets metadata and renders its view.
- **`hooks/`** holds hooks shared across features. A hook one feature uses stays in that feature; promote it when a second feature needs it.
- **`types/`** holds domain types and DTOs (the shapes that cross the network), one file per domain: `types/order.ts`.
- **`lib/<library>/index.ts`** re-exports what the app uses from a third-party library, configured once. The app imports `@/lib/<library>`, so swapping or configuring the library touches one folder. The framework itself (React, Next.js, Vue) is imported directly. `vi.mock('<package>')` still works on a wrapped package, since the wrapper re-exports the mocked module. Tests import Testing Library from `@/lib/testing-library`, which re-exports `render`, `screen`, `within` and `userEvent` (and a `render` wrapped in the app's providers when it has any).

## Files

- **kebab-case** for files and folders: `order-summary.tsx`, `use-cart.ts`, `order-summary.module.css`.
- **Named exports and imports.** A default export only where a framework requires one (a Next.js `page.tsx`, a config file); re-export it by name if other code imports it.
- **Sibling test.** Each implementation file sits next to its `<name>.test.ts(x)`. Barrels and type-only files have none.
- **Split when large.** Past ~300 lines, more than one concern, or a test file noticeably slower than its neighbours, split it:
  - Implementation → one file per concern in the same folder. The public import path stays the same: the feature's `index.ts` or the barrel re-exports the moved code.
  - Tests → one file per behaviour group: `order-summary.discounts.test.tsx`, `order-summary.empty-state.test.tsx`, each with its own setup.

## Tests

Mock and query by `tdd`'s rules: `vi.spyOn` on your own code, `vi.mock` only for third-party packages, `vi.stubGlobal` for web APIs, accessible queries in unit, integration and end-to-end tests. Call the Skill tool with `tdd` when writing them.

## Done when

Every file added or moved:

- [ ] sits in the folder the layout names, kebab-case
- [ ] uses named exports, and imports across folders through `@/`, a barrel, or a feature's `index.ts`
- [ ] has a sibling test, unless it is a barrel or type-only
- [ ] is under ~300 lines with one concern, or was split as above
