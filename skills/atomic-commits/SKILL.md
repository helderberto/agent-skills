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
4. Push the commits — but check the branch first:
   a. `git branch --show-current`
   b. If on the default branch (`main`/`master`): do NOT push. Most repos block or discourage direct pushes to the default branch (branch protection, pre-push hooks). Stop and tell the user, suggesting they move the commits onto a feature branch first (e.g. `git switch -c <feature-branch>`), then push.
   c. Otherwise: `git push` (relies on the branch's configured upstream)
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
- If a pre-push hook or branch-protection rule rejects the push → do not force or work around it; report the hook's message to the user and let them decide
- If unsure how to group a file → ask the user before committing
