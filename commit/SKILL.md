---
name: commit
description: Create git commits following repository style. Use when user asks to "create a commit", "commit changes", "/commit", or requests committing code to git.
disable-model-invocation: true
compatibility: Requires git
allowed-tools: Bash(git:*) Read
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

## Rules

- NEVER amend unless requested
- NEVER skip hooks
- NEVER commit secrets
- Only commit when requested
- Match existing commit patterns
