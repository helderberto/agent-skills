---
name: commit
effort: low
description: Group unstaged changes into atomic commits by concern, following repository style. Use when user asks to "commit", "create a commit", or "commit changes". Don't use for pushing (/ship) or creating pull requests.
---

# Git Commit

Group all unstaged/untracked changes into **atomic commits** — one commit per logical concern. A single concern is just the degenerate case: one commit. **Never push** — pushing belongs to `/ship`.

## Message style

Match the repo's existing commit patterns from `git log`. Extreme concision — sacrifice grammar for brevity. Focus on "why" not "what". Imperative mood. Conventional commits (`feat`/`fix`/`refactor`/`docs`/`chore` + scope) when the repo uses them.

## Workflow

1. Review full diff and status; read recent log for style.
2. Identify logical groups: feature/fix, its tests, config, formatting-only, docs, assets.
3. Per group: stage those files explicitly by name, commit with a HEREDOC message, confirm `git status` before the next group.
4. Finish with a clean working tree. Unsure how to group a file → ask.

## Grouping rules

- Formatting-only changes (whitespace, quotes, indentation) get their own commit, separate from logic.
- A file with both logic and formatting changes stays in the logic commit.
- Tests and the code they test can share a commit.
- Pre-commit hook fails → fix, re-stage, create a **new** commit; never `--amend`, never skip hooks.
