# Component Project Structures

## Flat (most common)

```
src/components/
  Button/
    Button.tsx
    Button.test.tsx
    Button.stories.tsx
    index.ts          ← re-export
```

Detection: glob `src/components/*/index.ts`

## Atomic Design

```
src/components/
  atoms/
    Button/
  molecules/
    SearchBar/
  organisms/
    Header/
```

Detection: glob `src/components/atoms/` or `src/components/molecules/`

## Feature Folders

```
src/features/
  auth/
    components/
      LoginForm/
    hooks/
    types.ts
```

Detection: glob `src/features/*/components/`

## Next.js App Router

```
app/
  (auth)/
    login/
      page.tsx
components/
  ui/              ← shared primitives (shadcn/ui pattern)
  <ComponentName>/
```

Detection: `app/` directory exists

---

## File naming conventions

| Pattern | Example |
|---|---|
| PascalCase file | `Button.tsx` |
| index re-export | `index.ts` with `export { Button } from './Button'` |
| Co-located test | `Button.test.tsx` next to component |
| Co-located story | `Button.stories.tsx` next to component |

## Export style detection

Read 2-3 existing components and match:

```tsx
// Named export (preferred in most projects)
export function Button() {}
export const Button = () => {}

// Default export (common in Next.js pages)
export default function Button() {}
```
