---
name: a11y
description: Audit accessibility compliance in frontend code. Use when user asks to "check accessibility", "/a11y", "audit a11y", "check WCAG", or wants to find accessibility issues.
compatibility: Requires React/Vue/Svelte project with JSX or HTML output. Optionally uses @axe-core/cli against a running dev server.
allowed-tools: Read Glob Grep Bash(npx:*) Bash(bunx:*)
---

# Accessibility Audit

## Workflow

1. Detect framework from `package.json` (React, Vue, Svelte)
2. Run static analysis — grep JSX/TSX/HTML files for violations (see [wcag-checklist.md](references/wcag-checklist.md)):
   - Missing `alt` on `<img>`
   - Missing `aria-label` on icon-only buttons and inputs without `<label>`
   - Non-semantic interactive elements (`<div onClick>`, `<span onClick>`)
   - Missing `htmlFor` / `for` on `<label>`
   - Heading hierarchy skips (h1 → h3)
   - Missing landmark roles (`<main>`, `<nav>`, `<header>`)
3. If dev server is running, optionally run axe-core CLI:
   ```bash
   npx @axe-core/cli@4 http://localhost:3000
   ```
4. Report findings grouped by severity

## Output format

Group by WCAG criterion:
- **Critical** (WCAG A) — blocks assistive technology users
- **Serious** (WCAG AA) — significantly impacts usability
- **Suggestions** — best practice improvements

Use `file:line` references. Include the fix for each finding.

## Rules

- Report `file:line` + violation + WCAG criterion + suggested fix
- Never auto-fix — always show what to change and why
- Prioritize keyboard navigation and screen reader issues
