---
name: source-driven
description: Implement features using official docs for exact dependency versions instead of training data. Use when user asks to "check the docs", "use official docs", "source-driven", or when implementing with unfamiliar APIs/libraries. Don't use for well-known stdlib APIs or project-internal code.
---

# Source-Driven Development

Never rely on training data for API usage. Read the actual source of truth.

## Workflow

### 1. Identify Dependencies

- Read `package.json` (or equivalent manifest) for exact versions
- Note the **exact version** of each library involved in the task

### 2. Fetch Official Docs

For each dependency involved:

1. Find the correct docs URL for that **specific version** (not "latest")
2. Fetch the relevant API page using WebFetch
3. Extract: function signatures, required params, return types, breaking changes

If docs are unavailable or ambiguous, read the library source in `node_modules/`.

### 3. Implement from Docs

- Use only APIs confirmed in fetched docs
- Match function signatures exactly (param order, types, defaults)
- If a doc page confirms the API: proceed
- If you cannot verify an API: mark it `// UNVERIFIED: could not confirm in docs for v{version}`

### 4. Cite Sources

Add a brief comment on non-obvious API usage:

```ts
// Ref: https://docs.example.com/v3/api#method
```

Only cite when the usage is surprising or version-specific. Don't over-comment obvious calls.

## Rules

- NEVER guess API signatures — fetch or read source
- NEVER assume "latest" docs match the installed version
- Always mark unverified claims with `// UNVERIFIED`
- Prefer `node_modules/` source over training knowledge when docs unavailable
- Don't cite every line — only non-obvious or version-sensitive usage

## Error Handling

- Docs URL returns 404 → try GitHub repo README, then `node_modules/` source
- Version not found in docs → use closest version docs + mark `// UNVERIFIED: docs for v{closest}, installed v{actual}`
- WebFetch blocked/unavailable → read `node_modules/{pkg}/README.md` or type definitions
