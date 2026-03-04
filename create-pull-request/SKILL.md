---
name: create-pull-request
description: Create GitHub pull requests. Use when user asks to "create a pull request", "open a PR", "/create-pull-request", or requests creating a pull request.
argument-hint: "[--draft]"
disable-model-invocation: true
allowed-tools: Bash(gh *), Bash(git *), Read, Glob
---

# Create Pull Request

Mode: $ARGUMENTS

If `--draft` is passed, create as draft PR.

## Pre-loaded context

- Branch status: !`git status && git branch -vv`
- Recent commits: !`git log --oneline -10`

## Workflow

1. Run in parallel:
   - `git diff HEAD`
   - `git diff [base-branch]...HEAD`
   - Search for PR template (see [template-locations.md](references/template-locations.md))
2. Read template if found
3. Review ALL commits (not just latest)
4. Draft title (<70 chars) and body:
   - Use template structure if available
   - Otherwise: Summary + Test plan
5. In parallel:
   - Create branch if needed
   - Push with `-u` if needed
   - Create PR with `gh pr create` using HEREDOC (add `--draft` if requested)

See [examples.md](examples.md) for output format and [gh-flags.md](references/gh-flags.md) for advanced options.

## Rules

- Use PR template if available
- Analyze ALL commits, not just the latest
- Return PR URL when done
- Use `gh` CLI only
- NEVER force push to main/master
- NEVER push without user confirmation if already on main/master
- NEVER create PR with uncommitted changes — commit first
