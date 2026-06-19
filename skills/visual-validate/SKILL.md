---
name: visual-validate
description: Validate UI changes in a real browser using Chrome DevTools or Playwright MCP. Takes screenshots, compares before/after, exercises interactions, captures console errors. Use when user asks to "visual validate", "/visual-validate", "check the UI", "screenshot before/after", or finishes a UI change. Don't use for unit tests (use `tdd`), E2E user flows (use `e2e`), or backend changes.
argument-hint: '[url]'
---

# Visual Validate

Drive a real browser via MCP to verify a UI change works as intended. Auto-detects which browser MCP is available (`chrome-devtools` preferred, `playwright` fallback). Screenshots, interactions, and console capture confirm the change is real — not just type-checked.

## Pre-loaded context

- Available MCPs: !`echo "Check via tool availability at runtime"`
- Branch: !`git branch --show-current`
- Last-changed UI files: !`git diff --name-only HEAD~1 -- '*.jsx' '*.tsx' '*.html' '*.css' 2>/dev/null | head -20`

## MCP Auto-Detection

At the start of the workflow, detect which MCP is available:

1. Check for `chrome-devtools` MCP tools (`mcp__chrome-devtools__*`)
2. If absent, check for `playwright` MCP tools (`mcp__playwright__*` or similar namespacing)
3. If neither → STOP with clear message: "No browser MCP available. Install `chrome-devtools` or `playwright` MCP server to use this skill."

State the detected MCP at the start: "Using chrome-devtools MCP for visual validation."

## Workflow

### Phase 1 — Setup

1. Confirm the dev server URL with the user (default to `http://localhost:3000` if a Next.js/Vite project is detected; otherwise ask).
2. If the dev server is not running, ask the user to start it. Do NOT start it automatically — port collisions are easy and dev servers are user state.
3. Open the page via the detected MCP:
   - chrome-devtools: `new_page` → `navigate_page`
   - playwright: equivalent navigate tool

### Phase 2 — Capture baseline (before)

4. Take a "before" screenshot of the relevant page/component. Save reference to it.
5. Capture the initial console state.
6. If the user provides a specific element or component to focus on, take an element-scoped screenshot via DOM snapshot.

### Phase 3 — Exercise the change

7. Ask the user what interactions to validate (e.g., "click the toggle", "submit form with X data", "resize to mobile width").
8. Execute interactions via MCP:
   - chrome-devtools: `click`, `fill`, `hover`, `press_key`, `resize_page`
   - playwright: equivalent tools
9. Wait for any animations / network requests to settle (`wait_for` or equivalent).

### Phase 4 — Capture after

10. Take "after" screenshot(s).
11. Capture console messages and any new network errors via `list_console_messages` and `list_network_requests`.
12. Run accessibility audit on the final state via `lighthouse_audit` (chrome-devtools) if available.

### Phase 5 — Report

13. Present findings in this structure:

```
## Visual Validation — <feature>

**MCP**: chrome-devtools (or playwright)
**URL**: <url>
**Interactions exercised**: <list>

### Screenshots
- Before: <path or reference>
- After: <path or reference>

### Console
- Errors: <count> — <summary>
- Warnings: <count>

### Network
- Failed requests: <count>
- Slow requests (>1s): <count>

### Accessibility (if lighthouse_audit ran)
- Score: <n>
- Critical issues: <list>

### Verdict
- PASS: change works as intended, no new console errors, no a11y regressions
- FAIL: console errors / a11y regressions / unexpected visual changes — list each issue with screenshot reference
```

## Rules

- Always auto-detect MCP at the start; never assume one is available
- Always take before + after screenshots — single screenshot is not a comparison
- Never start the dev server yourself; ask the user
- Never modify files during validation; this is read-only browser interaction
- Always close the browser page at the end (`close_page`) to free resources
- Capture console messages even on PASS — silent regressions surface in console first

## Error Handling

- No MCP available → STOP with installation hint (chrome-devtools or playwright MCP server setup)
- Dev server unreachable → ask user to confirm URL and start the server
- Navigation timeout (>30s) → report and stop; likely a build error or wrong URL
- MCP tool errors mid-flow → report which step failed, attempt cleanup (close_page), stop

## Choosing chrome-devtools vs playwright

- **chrome-devtools** preferred when: you need DevTools-specific features (lighthouse audit, network throttling, performance profiling, memory snapshots)
- **playwright** preferred when: you need cross-browser testing (Firefox, Safari/WebKit) or are validating against an existing Playwright test setup

If both are installed, this skill defaults to **chrome-devtools** for the richer audit surface. Override by stating "use playwright" in the user prompt.
