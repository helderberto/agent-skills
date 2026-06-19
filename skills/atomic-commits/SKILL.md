---
name: atomic-commits
description: Group unstaged changes into atomic commits by concern, then push. Use when user asks to "atomic commits", "commit by group", "group commits", or wants to split changes into related commits before pushing.
---

# Atomic Commits

## Goal

Group all unstaged/untracked changes into atomic commits — one commit per logical concern — then push.

## Workflow

1. Review full diff and status
2. Identify logical groups among changed files. Common groupings:
   - Feature or bug fix (src files implementing one thing)
   - Tests for that feature
   - Config changes (package.json, tsconfig, next.config, etc.)
   - Formatting-only changes (prettier, eslint --fix with no logic change)
   - Docs / README updates
   - Asset changes (images, fonts, public files)
3. For each group:
   a. Stage only those files explicitly by name (never `git add .` or `-A`)
   b. Write a commit message matching repo style from log
   c. Commit with HEREDOC format
   d. Run `git status` to confirm staging is clean before next group
4. After all commits: `git push`
5. Run `git status` to verify clean working tree

## Grouping Rules

- Formatting-only changes (whitespace, quotes, indentation) go in their own commit, separate from logic changes
- If a file has both logic and formatting changes, keep them together in the logic commit
- Tests and the code they test can be in the same commit

## Rules

- NEVER amend on hook failure — fix, re-stage, create a NEW commit
- NEVER push if there are unstaged changes left unintentionally — confirm with user first

## Error Handling

- If `git push` is rejected (non-fast-forward) → run `git pull --rebase` then retry push once
- If unsure how to group a file → ask the user before committing
