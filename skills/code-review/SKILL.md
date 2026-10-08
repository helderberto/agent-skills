---
name: code-review
effort: high
description: Review a GitHub PR or a diff for bugs, security, performance, and code quality. Use when asked to review a PR or give pull request feedback, even when the diff is pasted inline. Don't use for local uncommitted changes, creating PRs, or merging.
argument-hint: '[PR] [BUGS|SECURITY|PERFORMANCE]'
---

# Review Pull Request

Arguments: $ARGUMENTS — a PR number or URL, and/or a mode. `BUGS`, `SECURITY`, or `PERFORMANCE` narrows the review to that axis; otherwise apply all.

## Input

A diff pasted inline → review that text, nothing to fetch. Otherwise the PR number or URL, else the current branch's PR → `gh pr view` + `gh pr diff`. No PR found → ask for one.

## Approval standard

Approve when the change definitely improves overall code health, even if it isn't perfect. Don't block a change because it isn't how you would have written it. If it improves the codebase and follows its conventions, approve.

If the change is too large to review well (~1000+ lines), asking the author to split it is a valid outcome. Suggest a strategy: stack (small change, next one based on it), by file group, horizontal (shared code first, then consumers), or vertical (one end-to-end slice per PR).

## Review criteria

Review every changed file, not just the latest commit. Review the tests first: do they test behavior, cover the edge cases, and would they catch a regression? With the branch checked out locally, answer the last one by experiment: invert one condition the change adds, run the suite, restore the file. Still green → a missing test; name it.

- **Correctness**: logic bugs, off-by-ones, race conditions, unhandled states, missing error paths
- **Readability**: functions > 50 lines, nesting > 2 levels, dead code, unused imports
- **Security**: exposed secrets, unvalidated external data
- **Type safety & immutability**: `any` or unjustified assertions; in-place mutation of shared data
- **Patterns**: consistent with codebase conventions, no reinvented wheels
- **Performance**: unnecessary re-renders, O(n²) where O(n) works
- **Code smells**: match the diff against the baseline in [smells.md](references/smells.md) — always judgement calls; the repo's documented style overrides the baseline
- **Dependency upgrades** (manifest/lockfile in the diff): one dependency per change — a bulk bump that breaks hides which package did it; verify against the changelog, not the version number; review the lockfile diff (one direct bump pulls dozens of transitive changes); flag hand-edited lockfiles

## Output

Group by severity, `file:line` on every finding, a suggested fix for every Critical:

- **Critical** — must fix before merge (bugs, vulnerabilities)
- **Suggestions** — improvements worth considering
- **Nit** — minor and optional; label true nitpicks as Nit rather than dropping or inflating them
- **FYI** — informational
- **Positives** — good patterns to call out

One structural problem and ten nits: the structural problem _is_ the review — lead with it. Close with the verdict against the approval standard.
