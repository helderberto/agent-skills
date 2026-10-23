---
name: safe-repo
description: Scan the repository for committed secrets and sensitive data; `--diff [<base>]` scopes to a branch's changes. Use when asked to "check for sensitive data", "scan for secrets", or verify no credentials or company data are committed. Don't use for code-level security (/harden), dependency CVEs (/deps-audit), or non-git directories.
argument-hint: '[--diff [<base>]]'
---

# Safe Repository Check

## Context

Security audit for sensitive data in repository. Check for credentials, API keys, company-specific information, and PII.

## Modes

- **Default (full-scan)**: scans all git-tracked files plus history. Use for periodic audits or first-time repo review.
- **`--diff [<base>]`**: scans only what changed: the branch's commits since `<base>`, plus staged + unstaged changes. No `<base>` → staged + unstaged only. Use before a commit, from `review`, or from `to-pr --safe`. Fast, no false positives from pre-existing files.

## Workflow

### Default (full-scan)

1. Run `bash ${CLAUDE_SKILL_DIR}/scripts/scan-secrets.sh` to scan all tracked files for credential patterns
2. Check for sensitive tracked files by name: `.env*` (except `.env.example`), `*.pem`, `*.key`, `*_rsa*`, `*secret*`, `*credential*`
3. Analyze git history for removed secrets: `git log --all --full-history -- "*.env" "*.pem" "*.key" "*secret*" "*credential*"`
4. Review `.gitignore` for proper patterns
5. Report findings (see [assets/report-template.md](assets/report-template.md))

### `--diff` mode

1. Compute changed files: `git diff --name-only <base>...HEAD` when a base is given, plus `git diff --name-only HEAD` + `git diff --name-only --cached`
2. Scan only those files with the regexes in `${CLAUDE_SKILL_DIR}/scripts/scan-secrets.sh` (grep them directly) plus the filename checks above
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

- If git history scan is slow → limit to last 100 commits with `git log --oneline -100`
