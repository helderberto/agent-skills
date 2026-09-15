---
name: source-driven
description: Implement features from official docs for the exact installed dependency versions, not training data. Use when asked to "check the docs", "use official docs", "source-driven", or with unfamiliar APIs/libraries. Don't use for well-known stdlib APIs or project-internal code.
---

# Source-Driven Development

Never rely on training data for API usage. Read the source of truth for the **installed version**.

1. **Pin versions** — read the project manifest/lockfile for the exact version of each library involved.
2. **Fetch docs for that version** (not "latest") with WebFetch. Extract signatures, required params, return types, breaking changes. Docs missing or ambiguous → the repo README for that tag, then the installed package source (`node_modules/`, site-packages, vendor, …) and its type definitions.
3. **Implement only confirmed APIs**, matching signatures exactly. Anything you cannot verify gets marked inline: `// UNVERIFIED: could not confirm in docs for v{version}` (or `docs for v{closest}, installed v{actual}`).
4. **Cite** surprising or version-specific usage with a one-line `// Ref: <url>`. Don't comment obvious calls.
