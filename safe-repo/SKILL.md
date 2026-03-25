---
name: safe-repo
description: Check for sensitive data in repository. Use when user asks to "check for sensitive data", "/safe-repo", or wants to verify no company/credential data is in the repository. Don't use for general code review, adding .gitignore entries, or scanning non-git directories.
---

# Safe Repository Check

## Context

Security audit for sensitive data in repository. Check for credentials, API keys, company-specific information, and PII.

## Workflow

1. Run `bash scripts/scan-secrets.sh` to scan all tracked files for credential patterns
   (see [references/patterns.md](references/patterns.md) for full pattern list)
2. Check for sensitive tracked files (.env, secrets)
4. Analyze git history for removed secrets
5. Review `.gitignore` for proper patterns
6. Report findings (see [assets/report-template.md](assets/report-template.md))

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
