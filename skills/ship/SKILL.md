---
name: ship
description: Commit and push changes using atomic commits. Use when user asks to "ship", "commit and push", or requests committing and pushing changes. Don't use for creating pull requests or reviewing changes before committing.
---

# Ship Changes

## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
- Log: !`git log --oneline -10`

## Workflow

1. Review all changes from status and diff
2. Analyze recent commit style from log
3. Check for quality check commands:
   - If `package.json` exists, check for `lint` and `test` scripts
   - Run available checks in parallel: `npm run lint`, `npm test`
   - If no package.json, skip quality checks
4. If checks fail: report errors, STOP — do not commit or push
5. Group changed files by logical concern using [atomic-commits grouping rules](../atomic-commits/SKILL.md#grouping-rules)
6. For each group: stage specific files by name, commit with HEREDOC format
7. If all changes form one logical unit, stage files by name (never `git add -A` or `git add .`)
8. Push: `git push` (current branch)
9. Run `git status` after to verify

## Rules

- Stage files by name, never `git add -A` or `git add .`
- Group changes into atomic commits when they serve distinct purposes
- Generate message from changed files, match repo style
- Only run package manager commands if package.json exists with those scripts
- NEVER push if lint or tests fail
- NEVER force push (`-f` or `--force`)
- NEVER skip hooks
- NEVER commit secrets
- Push to current branch only

## Error Handling

- If lint or tests fail → report all errors, stop; do not commit or push
- If `git push` is rejected (non-fast-forward) → run `git pull --rebase` then retry push once
- If pre-commit hook fails → fix reported issues, re-stage, create a NEW commit (never `--amend`)
