---
name: safe-repo
description: Check for sensitive data in repository. Use when user asks to "check for sensitive data", "/safe-repo", or wants to verify no company/credential data is in the repository. Use `--diff` mode to scope to staged + unstaged changes only (e.g., before commit). Don't use for general code review, adding .gitignore entries, or scanning non-git directories.
argument-hint: '[--diff]'
---

# Safe Repository Check

## Context

Security audit for sensitive data in repository. Check for credentials, API keys, company-specific information, and PII.

## Modes

- **Default (full-scan)**: scans all git-tracked files plus history. Use for periodic audits or first-time repo review.
- **`--diff`**: scans only staged + unstaged changes (`git diff` + `git diff --cached`). Use before commit or when called from `review` / `ship` workflows. Fast, no false positives from pre-existing files.

## Workflow

### Default (full-scan)

1. Run `bash scripts/scan-secrets.sh` to scan all tracked files for credential patterns
   (see [references/patterns.md](references/patterns.md) for full pattern list)
2. Check for sensitive tracked files (.env, secrets)
3. Analyze git history for removed secrets
4. Review `.gitignore` for proper patterns
5. Report findings (see [assets/report-template.md](assets/report-template.md))

### `--diff` mode

1. Compute changed files: `git diff --name-only HEAD` + `git diff --name-only --cached`
2. Scan only those files against the credential patterns
3. Skip history analysis (not relevant for in-flight changes)
4. Report findings scoped to changed files only

## Rules

- **Only check git-tracked files** (`git ls-files`) - ignore local configs
- Check current tracked files AND git history
- Filter false positives: minified JS, node_modules, test fixtures, docs
- Verify `.gitignore` covers sensitive patterns
- Report tracked files with secrets and historical commits
- Never output actual secret values in report

## Error Handling

- If `git ls-files` returns nothing → verify the current directory is a git repository; run `git status` to confirm
- If git history scan is slow → limit to last 100 commits with `git log --oneline -100`
- If false positives are high → cross-reference against patterns in [references/patterns.md](references/patterns.md) before reporting
