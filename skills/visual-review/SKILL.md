---
name: visual-review
effort: high
description: Two visual modes — render a PR diff as an HTML page with each hunk annotated by principle, or check a UI change in a real browser (screenshots, console, network). Use for a visual/HTML diff report, "check the UI", or "screenshot before/after". Don't use for text-only feedback (/code-review), unit tests (/tdd), or multi-reviewer review (/review).
user-invocable: false
argument-hint: '[pr-url-or-number] | --ui [url]'
---

# Visual Review

Two modes. **Diff mode** (default) annotates a PR diff as HTML. **UI mode** (`--ui [url]`) checks a UI change in a real browser; see [UI mode](#ui-mode).

## Diff mode

Turn a PR diff into an annotated HTML page you scan in a browser. Each finding sits next to its code and explains the **why** — the principle it touches and how to simplify — so you decide what to comment on the PR yourself. Read-only: this never posts to the PR or touches the branch.

Sibling of `code-review` (text feedback). Its edge is the visual artifact and the teaching: findings link to [`references/principles.md`](references/principles.md).

The lens covers design and simplification — readability and simplification, SOLID and design principles, testability, reusability, and maintainability: how to make each changed block clearer, more reusable, and easier to test. Bugs, security, and scope/claim mismatches (does the diff do what the PR description says?) stay out of scope — `/code-review` covers those.

### Workflow

#### Phase 1 — Resolve the PR

1. If a PR URL or number was passed as the argument, use it. Otherwise detect the PR for the current branch:
   ```bash
   gh pr view --json number,title,author,url,baseRefName,headRefName
   ```
   Completion: PR number, title, author, and URL are known. No PR and no argument → stop and ask for a URL or number.

#### Phase 2 — Fetch the diff

2. Pull the unified diff and the file list, then read each changed file **at head** for full context — a hunk alone hides the surrounding code the finding depends on:
   ```bash
   gh pr diff <number>
   gh pr view <number> --json files
   ```
   Completion: every changed file read for context (skip deleted files, note them as removed).

#### Phase 3 — Annotate each hunk

3. Assess each meaningful hunk against the lens in [`references/principles.md`](references/principles.md). Raise a finding only where there's a real observation — a must-fix, a worth-considering, or a praise. Capture per finding: `file:line`, severity, principle tag, the **why** (the reasoning is the point, not the verdict), and a concrete `before → after` rewrite when the fix is actionable.
   Completion: every changed hunk considered; each finding carries a principle tag and a why.

#### Phase 4 — Render the HTML

4. Clone [`assets/report-template.html`](assets/report-template.html). Fill the header (title, number, author, PR link), the summary counts, and one finding card per finding — grouped by file, ordered by severity within each file. Keep it self-contained: inline CSS/JS, no CDN, so it opens offline via `file://`.
   Write to `<tmpdir>/visual-review-pr-<number>.html`, where `<tmpdir>` is `$TMPDIR`, else `/tmp` (`%TEMP%` on Windows). Never the working tree: the next `commit` would sweep the report in.
   Completion: file written with every finding rendered.

5. Open it and report the absolute path:
   ```bash
   open <tmpdir>/visual-review-pr-<number>.html   # macOS; xdg-open on Linux
   ```
   Completion: path printed; browser opened.

### Rules

- Read-only on the PR. The page is your review surface; you comment on GitHub afterward.
- Annotate the why, not just the verdict — the explanation is what makes it worth more than an inline comment.
- Self-contained HTML only. No external fonts/scripts/styles, so the file works offline.

### Error Handling

- `gh pr view` fails → run `gh auth status` to check auth; ask for a PR number if not on a PR branch.
- No PR for the current branch and no argument passed → ask for a PR URL or number.
- File deleted in the PR → skip reading it; note it as removed in the report.
- Diff too large → prioritize highest-risk files (auth, payments, data mutation, shared modules); note in the summary which files were truncated.

## UI mode

Drive a real browser to confirm a UI change is real — not just type-checked. Read-only: never modify files.

### Setup

- Use whichever browser MCP is available — `chrome-devtools` preferred (lighthouse, throttling, profiling), `playwright` for cross-browser or an existing Playwright setup. Neither → stop and tell the user to install one. State which you're using.
- Confirm the dev server URL (the URL after `--ui`, or the project's default, else ask). If it isn't running, ask the user to start it — **never start it yourself**; port collisions are easy and dev servers are user state.

### Workflow

1. **Before**: screenshot the relevant page/component; capture the initial console state.
2. **Exercise**: ask which interactions to validate (click, fill, resize to mobile, …); perform them; wait for animations and network to settle.
3. **After**: screenshot again; collect console messages, failed and slow (>1s) network requests; run the accessibility audit if the MCP offers one.
4. Close the page.

### Report

```
## Visual Validation — <feature>
**MCP**: … · **URL**: … · **Interactions**: …
Screenshots: before / after
Console: <errors> errors, <warnings> warnings
Network: <failed> failed, <slow> slow
Accessibility: score / critical issues (if run)
Verdict: PASS (works as intended, no new console errors, no a11y regression) or FAIL (each issue with screenshot reference)
```

Report console output even on PASS — silent regressions surface there first. A flow worth re-checking on every change → an end-to-end test, per [ui-tests.md](../tdd/references/ui-tests.md).
