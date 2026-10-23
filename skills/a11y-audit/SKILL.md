---
name: a11y-audit
description: Audit accessibility (WCAG) in frontend code. Use when asked to "check accessibility", "audit a11y", "check WCAG", or find accessibility issues. Don't use for backend code, bundle size (/perf-audit), or translations (/i18n).
---

# Accessibility Audit

## Workflow

1. Detect framework from `package.json` (React, Vue, Svelte)
2. Run static analysis -- grep JSX/TSX/HTML files for violations
3. If dev server is running, optionally run axe-core CLI:
   ```bash
   npx @axe-core/cli@4 http://localhost:3000
   ```
4. Report findings grouped by severity

## Output format

Group by WCAG criterion:
- **Critical** (A) -- blocks assistive technology users
- **Serious** (AA) -- significantly impacts usability
- **Suggestions** -- best practice improvements

Use `file:line` references. Include the fix for each finding. Prioritize keyboard navigation and screen reader issues; never auto-fix -- show what to change and why.

## Error Handling

- Framework undetected -- scan all `.html`, `.jsx`, `.tsx`, `.vue` files
