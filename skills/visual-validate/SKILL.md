---
name: visual-validate
description: Validate UI changes in a real browser via Chrome DevTools or Playwright MCP — before/after screenshots, console and network capture. Use when asked to "visual validate", "check the UI", "screenshot before/after", or after a UI change. Don't use for unit tests (/tdd), E2E flows (/e2e), or backend changes.
argument-hint: '[url]'
---

# Visual Validate

Drive a real browser to confirm a UI change is real — not just type-checked. Read-only: never modify files.

## Setup

- Use whichever browser MCP is available — `chrome-devtools` preferred (lighthouse, throttling, profiling), `playwright` for cross-browser or an existing Playwright setup. Neither → stop and tell the user to install one. State which you're using.
- Confirm the dev server URL (`$ARGUMENTS`, or the project's default, else ask). If it isn't running, ask the user to start it — **never start it yourself**; port collisions are easy and dev servers are user state.

## Workflow

1. **Before**: screenshot the relevant page/component; capture the initial console state.
2. **Exercise**: ask which interactions to validate (click, fill, resize to mobile, …); perform them; wait for animations and network to settle.
3. **After**: screenshot again; collect console messages, failed and slow (>1s) network requests; run the accessibility audit if the MCP offers one.
4. Close the page.

## Report

```
## Visual Validation — <feature>
**MCP**: … · **URL**: … · **Interactions**: …
Screenshots: before / after
Console: <errors> errors, <warnings> warnings
Network: <failed> failed, <slow> slow
Accessibility: score / critical issues (if run)
Verdict: PASS (works as intended, no new console errors, no a11y regression) or FAIL (each issue with screenshot reference)
```

Report console output even on PASS — silent regressions surface there first.
