---
name: atomic-commits
description: Group unstaged changes into atomic commits by concern, then push. Use when user asks to "atomic commits", "commit by group", "group commits", or wants to split changes into related commits before pushing.
---

# Atomic Commits

## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
- Log: !`git log --oneline -10`

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

- One commit = one reason to change
- Formatting-only changes (whitespace, quotes, indentation) go in their own commit, separate from logic changes
- Never mix unrelated concerns in one commit (e.g. bug fix + formatting + config)
- If a file has both logic and formatting changes, keep them together in the logic commit
- Tests and the code they test can be in the same commit

## Commit Message Rules

- Match existing commit patterns from `git log`
- Extreme concision, imperative mood
- Focus on "why" not "what"

## Rules

- NEVER use `git add .` or `git add -A`
- NEVER amend unless requested
- NEVER skip hooks
- NEVER commit secrets
- NEVER push if there are unstaged changes left unintentionally — confirm with user first

## Error Handling

- If pre-commit hook fails → fix reported issue, re-stage changed files, create a NEW commit (never `--amend`)
- If `git push` is rejected (non-fast-forward) → run `git pull --rebase` then retry push once
- If unsure how to group a file → ask the user before committing
