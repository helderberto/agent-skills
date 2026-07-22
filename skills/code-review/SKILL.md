---
name: code-review
effort: high
description: Review a GitHub Pull Request for bugs, security, performance, and code quality. Use when user asks to review a PR or wants pull request feedback. Don't use for reviewing local uncommitted changes, creating new PRs, or merging branches.
---

# Review Pull Request

Mode: $ARGUMENTS

If mode is one of the following, adjust the review:
- BUGS: Focus only on logical or other bugs
- SECURITY: Focus only on security issues
- PERFORMANCE: Focus only on performance issues

## Workflow

1. Analyze the diff and pre-loaded PR context
2. Read changed files to understand full context
3. Review based on mode (or all categories if no mode set)
4. Provide structured feedback

## Review criteria

Apply all axes (or narrow to the mode above):

- **Correctness**: Logic bugs, off-by-ones, race conditions, unhandled states, missing error paths
- **Readability**: Functions <50 lines, nesting <3 levels, no dead code/unused imports
- **Security**: No exposed secrets, no `any`, no unvalidated external data
- **Immutability**: No push/pop/splice/direct mutation
- **Patterns**: Consistent with codebase conventions, no reinvented wheels
- **Performance**: Unnecessary re-renders, O(n²) where O(n) works, missing memoization
- **Code smells**: Duplicated code, parameters >3 without options object, magic numbers

## Output format

Group by severity:
- **Critical** - must fix before merge (bugs, security vulnerabilities)
- **Suggestions** - improvements worth considering
- **Positives** - good patterns to call out

Use `file:line` references for all findings. Include suggested fix for each critical issue.

## Rules

- Review ALL changed files, not just the latest commit
- Be specific, skip nitpicks

## Common Rationalizations

| Excuse | Rebuttal |
|--------|----------|
| "Too small to review" | Small changes cause big bugs — review everything |
| "It's just a refactor" | Refactors break behavior silently — verify contracts preserved |
| "Tests pass so it's fine" | Tests don't catch readability, security, or design issues |
| "I'll clean it up later" | Later never comes — fix now or it ships as-is |

## Verification

- [ ] Every changed file reviewed (not just the diff summary)
- [ ] No critical issue left without a suggested fix
- [ ] Security concerns flagged with specific fix
- [ ] Feedback grouped by severity, not file order

## Error Handling

- If `gh pr view` fails → run `gh auth status` to verify authentication; ask user for PR number if not on a PR branch
- If a changed file is deleted in the PR → skip reading it; note it was removed
- If diff is too large → prioritize changed files with highest risk (auth, payments, data mutation)
