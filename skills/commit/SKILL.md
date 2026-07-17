---
name: commit
effort: low
description: Group unstaged changes into atomic commits by concern, following repository style. Use when user asks to "commit", "create a commit", "commit changes", or "/commit". Don't use for pushing (that belongs to /ship) or creating pull requests.
---

# Git Commit

Group all unstaged/untracked changes into **atomic commits** — one commit per logical concern. A single concern is just the degenerate case: one commit. **Never push** — pushing belongs to the `/ship` cycle.

## Message Style

Match the repo's existing commit patterns from log.

- Extreme concision — sacrifice grammar for brevity
- Focus on "why" not "what"
- Imperative mood
- Conventional commits when the repo uses them (`feat`/`fix`/`refactor`/`docs`/`chore` + scope)

## Workflow

1. Review full diff and status
2. Analyze recent commit style from log
3. Identify logical groups among the changed files. Common groupings:
   - Feature or bug fix (src files implementing one thing)
   - Tests for that feature
   - Config changes (`package.json`, `tsconfig`, etc.)
   - Formatting-only changes (no logic change)
   - Docs / README updates
   - Asset changes (images, fonts, public files)
4. For each group:
   a. Stage only those files explicitly by name (never `git add .` or `-A`)
   b. Write a commit message matching repo style
   c. Commit with HEREDOC format
   d. Run `git status` to confirm staging is clean before the next group
5. Run `git status` to verify a clean working tree

## Grouping Rules

- Formatting-only changes (whitespace, quotes, indentation) go in their own commit, separate from logic changes
- If a file has both logic and formatting changes, keep them together in the logic commit
- Tests and the code they test can share a commit

## Examples

**Single concern** — one commit:

```bash
git add src/auth.ts
git commit -m "fix: null check in login handler"
```

**Multiple concerns** — split:

```bash
git add src/components/SearchBar.tsx src/hooks/useSearch.ts
git commit -m "feat: add search bar component"
git add README.md
git commit -m "docs: document search usage"
```

## Rules

- NEVER push — pushing belongs to `/ship`
- NEVER `git add .` or `-A` — stage explicitly by name
- NEVER amend unless requested
- NEVER skip hooks
- NEVER commit secrets

## Error Handling

- Pre-commit hook fails → fix the issue, re-stage, create a NEW commit (never `--amend`)
- If unsure how to group a file → ask the user before committing
