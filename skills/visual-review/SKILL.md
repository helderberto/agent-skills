---
name: visual-review
effort: high
description: Render a GitHub Pull Request diff as a self-contained HTML page where each changed hunk is annotated with a software-principle explanation and a suggested simplification. Use when the user wants to review a PR visually, generate an HTML/visual diff report, or see PR feedback linked to principles (e.g. an unnecessary useMemo/useCallback) before commenting. Don't use for text-only PR feedback (use code-review), browser UI screenshots (use visual-validate), or orchestrating multiple reviewers (use review).
argument-hint: '[pr-url-or-number]'
---

# Visual Review

Turn a PR diff into an annotated HTML page you scan in a browser. Each finding sits next to its code and explains the **why** — the principle it touches and how to simplify — so you decide what to comment on the PR yourself. Read-only: this never posts to the PR or touches the branch.

Sibling of [`code-review`](../code-review/SKILL.md) (text feedback) and [`visual-validate`](../visual-validate/SKILL.md) (browser UI). Its edge is the visual artifact and the teaching: findings link to [`references/principles.md`](references/principles.md).

The lens covers design and simplification — readability and simplification, SOLID and design principles, testability, reusability, and maintainability: how to make each changed block clearer, more reusable, and easier to test. Bugs, security, and scope/claim mismatches (does the diff do what the PR description says?) stay out of scope — run [`code-review`](../code-review/SKILL.md) for those.

## Workflow

### Phase 1 — Resolve the PR

1. If a PR URL or number was passed as the argument, use it. Otherwise detect the PR for the current branch:
   ```bash
   gh pr view --json number,title,author,url,baseRefName,headRefName
   ```
   Completion: PR number, title, author, and URL are known. No PR and no argument → stop and ask for a URL or number.

### Phase 2 — Fetch the diff

2. Pull the unified diff and the file list, then read each changed file **at head** for full context — a hunk alone hides the surrounding code the finding depends on:
   ```bash
   gh pr diff <number>
   gh pr view <number> --json files
   ```
   Completion: every changed file read for context (skip deleted files, note them as removed).

### Phase 3 — Annotate each hunk

3. Assess each meaningful hunk against the lens in [`references/principles.md`](references/principles.md). Raise a finding only where there's a real observation — a must-fix, a worth-considering, or a praise. Capture per finding: `file:line`, severity, principle tag, the **why** (the reasoning is the point, not the verdict), and a concrete `before → after` rewrite when the fix is actionable.
   Completion: every changed hunk considered; each finding carries a principle tag and a why.

### Phase 4 — Render the HTML

4. Clone [`assets/report-template.html`](assets/report-template.html). Fill the header (title, number, author, PR link), the summary counts, and one finding card per finding — grouped by file, ordered by severity within each file. Keep it self-contained: inline CSS/JS, no CDN, so it opens offline via `file://`.
   Write to `visual-review-pr-<number>.html` at the repo root.
   Completion: file written with every finding rendered.

5. Open it and report the path:
   ```bash
   open visual-review-pr-<number>.html   # macOS; xdg-open on Linux
   ```
   Completion: path printed; browser opened.

## Rules

- Read-only on the PR. The page is your review surface; you comment on GitHub afterward.
- Annotate the why, not just the verdict — the explanation is what makes it worth more than an inline comment.
- Self-contained HTML only. No external fonts/scripts/styles, so the file works offline.

## Error Handling

- `gh pr view` fails → run `gh auth status` to check auth; ask for a PR number if not on a PR branch.
- No PR for the current branch and no argument passed → ask for a PR URL or number.
- File deleted in the PR → skip reading it; note it as removed in the report.
- Diff too large → prioritize highest-risk files (auth, payments, data mutation, shared modules); note in the summary which files were truncated.
