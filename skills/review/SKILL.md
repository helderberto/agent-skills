---
name: review
effort: high
description: Orchestrated REVIEW phase — fan out parallel read-only reviewers over a diff (scope-detected audit skills plus agent lenses), then consolidate into one severity-ranked verdict. Use for a full pre-ship review, "review this PR", or "spawn agents to review". Don't use for a single focused audit (call it directly) or to triage existing comments (/triage-review).
argument-hint: '[PR-number-or-branch] [agent-count]'
---

# Review Phase

Resolve the diff, fan out **parallel read-only reviewers** — each in its own subagent so a11y and security reasoning don't bleed into each other — and consolidate into one severity-ranked verdict. Findings two reviewers reach independently are the highest signal — surface that convergence.

Reviewers come from two sources: **audit skills** selected by file type in the diff (`a11y-audit`, `i18n`, `perf-audit`, `deps-audit`, `harden`, `safe-repo`) and **agent lenses** applied to the whole diff (correctness, test effectiveness, type safety, architecture friction).

## Workflow

### 1. Resolve the diff

PR number → `gh pr view` + `gh pr diff`. Branch → `git diff <base>...<branch>`. Nothing → `git merge-base HEAD main` (fall back `master`, `origin/HEAD`, then `HEAD~10` with a warning), then `git diff <base>...HEAD`. Empty diff → "Nothing to review", stop. State the scope: "Reviewing branch `X` vs `main` — 6 files, 224 insertions."

### 2. Select reviewers

Always: correctness (`code-review`), sensitive data (`safe-repo` diff-only), test effectiveness. Add the rest from the diff. Default 3–5 total; honor an explicit count from `$ARGUMENTS`.

| Reviewer | When | Agent type |
|----------|------|------------|
| Correctness (`code-review`) | always | `general-purpose` |
| Sensitive data (`safe-repo` diff-only) | always | `general-purpose` |
| Test effectiveness | always | `test-auditor` |
| Accessibility (`a11y-audit`) | JSX/TSX/HTML/CSS changed | `general-purpose` |
| User-facing strings (`i18n`) | new JSX text / template literals | `general-purpose` |
| Bundle / perf (`perf-audit`) | `package.json`, bundler config changed | `general-purpose` |
| Dependencies (`deps-audit`) | manifest / lockfile changed | `general-purpose` |
| Trust boundaries (`harden`) | routes, controllers, models, SQL, auth/input/external calls | `general-purpose` |
| Type safety | heavy type-level changes | `general-purpose` |
| Architecture friction | cross-module changes | `general-purpose` (uses `codebase-design` vocabulary) |

Match each reviewer to an agent type **available in the harness**; never invent one. Announce chosen reviewers before spawning and skip irrelevant ones with a one-line reason.

### 3. Fan out

Spawn all reviewers in **one message** so they run concurrently. Each gets: repo path (note if it's a worktree), the exact diff command and its subset of files, one paragraph of context, its instruction (run the audit skill via the Skill tool, or apply the lens), a pointer to `.specs/plans/*.md` if present, and the output contract — findings with `file:line`, severity (`critical` / `important` / `suggestion`), one-line rationale. **Read-only**: no edits, staging, commits, or pushes.

**Build/install collisions**: `perf-audit` builds and `deps-audit` may touch `node_modules` — give those worktree isolation or run them serially after the read-only reviewers.

### 4. Consolidate

Merge findings, dedupe, and flag convergence (≥2 reviewers on the same line). A subagent that errors is noted as skipped, not silently dropped. Relay each reviewer's real severity — don't inflate or bury. Drop a finding only if you verified it's already handled, and say why.

```
## Review Summary
**Scope**: <files/lines> · **Reviewers**: <list>

### Critical (blocks merge) — correctness, security, sensitive data, WCAG A
### Important (fix before merge) — architecture friction, missing tests, known CVEs
### Suggestions — style, naming, optional perf
### Converged (≥2 reviewers agreed)
### Non-issues — flagged but fine, with why
```

### 5. Verdict

**APPROVE** (zero Critical, zero Important) · **REQUEST CHANGES** (any Critical, or 3+ Important) · **NEEDS DISCUSSION** (Important findings involving architectural tradeoffs). Offer next steps; never auto-fix.
