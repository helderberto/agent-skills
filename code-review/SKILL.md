---
name: code-review
description: Review a GitHub Pull Request for bugs, security, performance, and code quality. Use when user asks to review a PR or wants pull request feedback.
argument-hint: "[bugs|security|performance]"
disable-model-invocation: true
context: fork
agent: Explore
allowed-tools: Bash(gh:*) Read Glob Grep
compatibility: Requires gh CLI with an active authenticated session
---

# Review Pull Request

Mode: $ARGUMENTS

If mode is one of the following, adjust the review:
- BUGS: Focus only on logical or other bugs
- SECURITY: Focus only on security issues
- PERFORMANCE: Focus only on performance issues

## Pre-loaded context

- PR details: !`gh pr view`
- PR diff: !`gh pr diff`
- Changed files: !`gh pr diff --name-only`

## Workflow

1. Analyze the diff and pre-loaded PR context
2. Read changed files to understand full context
3. Review based on mode (or all categories if no mode set)
4. Provide structured feedback

## Output format

Group by severity:
- **Critical** - must fix before merge (bugs, security vulnerabilities)
- **Suggestions** - improvements worth considering
- **Positives** - good patterns to call out

Use `file:line` references for all findings. Include suggested fix for each critical issue.

See [examples.md](examples.md) for output format and [review-checklist.md](references/review-checklist.md) for full checklist.

## Rules

- Review ALL changed files, not just the latest commit
- Be specific: file:line + issue + suggested fix
- Separate critical issues from suggestions
