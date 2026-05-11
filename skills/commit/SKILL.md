---
name: commit
description: Create git commits following repository style. Use when user asks to "create a commit", "commit changes", "/commit", or requests committing code to git. Don't use for pushing code, creating pull requests, or reviewing changes.
---

# Git Commit

## Pre-loaded context

- Status: !`git status`
- Diff: !`git diff HEAD`
- Log: !`git log --oneline -10`

## Message Style

Match repo's existing commit patterns from log.
- Extreme concision, sacrifice grammar for brevity
- Focus on "why" not "what"
- Imperative mood

## Workflow

1. Review status and diff
2. Analyze recent commit style from log
3. Stage files explicitly (avoid `git add .` or `-A`)
4. Commit with HEREDOC format matching repo style
5. Run `git status` after to verify

## Examples

**Bug fix** -- single file:
```bash
git add src/auth.ts
git commit -m "fix: null check in login handler"
```

**Feature** -- multiple related files:
```bash
git add src/components/SearchBar.tsx src/hooks/useSearch.ts
git commit -m "add search bar component"
```

**Refactor** -- extraction:
```bash
git add src/utils/validation.ts
git commit -m "extract email validation to util"
```

## Rules

- NEVER amend unless requested
- NEVER skip hooks
- NEVER commit secrets
- Only commit when requested
- Match existing commit patterns

## Error Handling

- Pre-commit hook fails -- fix issue, re-stage, create NEW commit (never `--amend`)
- Nothing to commit -- report clean working tree and stop
- Staged files contain secrets -- abort, warn user, unstage the file

## See Also

- [atomic-commits](../atomic-commits/SKILL.md) -- split changes into grouped commits by concern
