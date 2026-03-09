# Commit Examples

## Example 1: Bug Fix

**Context:**
- Changed: `src/auth.ts`
- Fixed null pointer error in login handler

**Commit:**
```bash
git add src/auth.ts
git commit -m "fix: null check in login handler"
```

## Example 2: Feature Addition

**Context:**
- Added: `src/components/SearchBar.tsx`, `src/hooks/useSearch.ts`
- New search functionality

**Commit:**
```bash
git add src/components/SearchBar.tsx src/hooks/useSearch.ts
git commit -m "add search bar component"
```

## Example 3: Refactor

**Context:**
- Modified: `src/utils/validation.ts`
- Extracted duplicate validation logic

**Commit:**
```bash
git add src/utils/validation.ts
git commit -m "extract email validation to util"
```

## Example 4: Multiple Related Changes

**Context:**
- Modified: `src/api/client.ts`, `src/types/api.ts`, `tests/api.test.ts`
- Added retry logic to API client

**Commit:**
```bash
git add src/api/client.ts src/types/api.ts tests/api.test.ts
git commit -m "add retry logic to api client"
```

## Style Guidelines

Match repository patterns:
- **Conventional commits**: `feat:`, `fix:`, `refactor:`, `test:`
- **Imperative**: "add feature" not "added feature"
- **Concise**: sacrifice grammar for brevity
- **Why not what**: focus on intent, code shows what changed
