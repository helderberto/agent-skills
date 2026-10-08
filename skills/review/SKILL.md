---
name: review
effort: high
description: Fan out parallel read-only reviewers over a diff and consolidate into one severity-ranked verdict. Use for a full pre-ship review, "review/validate this PR", or "spawn agents to review". Don't use for a single-lens PR review (/code-review), one audit, or triaging existing comments (/triage-review).
argument-hint: '[PR-number-or-branch] [agent-count]'
---

# Review Phase

Resolve the diff, fan out **parallel read-only reviewers** — each in its own subagent so a11y and security reasoning don't bleed into each other — and consolidate into one severity-ranked verdict. Findings two reviewers reach independently are the highest signal — surface that convergence.

Reviewers come from two sources: **audit skills** selected by file type in the diff (`a11y-audit`, `i18n`, `perf-audit`, `deps-audit`, `harden`, `safe-repo`) and **agent lenses** applied to the whole diff (correctness, standards, spec conformance, test effectiveness, type safety, architecture friction). The quality-bar check is a script you run inline.

## Workflow

### 1. Resolve the diff

PR number → `gh pr view` + `gh pr diff` (fails → current-branch diff, warn). Branch → `git diff <base>...<branch>`. Nothing → `git merge-base HEAD main` (fall back `master`, `origin/HEAD`, then `HEAD~10` with a warning), then `git diff <base>...HEAD`. Empty diff → "Nothing to review", stop. State the scope: "Reviewing branch `X` vs `main` — 6 files, 224 insertions."

### 2. Select reviewers

Always: correctness (`code-review`), standards, sensitive data (`safe-repo` diff-only), test effectiveness, quality bar. Spec whenever `.specs/specs/` holds this work's spec. Add the rest from the diff. An explicit count in `$ARGUMENTS` (2–8) caps the subagents; drop diff-selected ones first. Never spawn `e2e` or `visual-validate` — those are VERIFY phase, not REVIEW.

| Reviewer | When | Agent type |
|----------|------|------------|
| Correctness (`code-review`) | always | `general-purpose` |
| Standards | always | `general-purpose` |
| Spec conformance | `.specs/specs/<slug>.md` matches the branch or plan | `general-purpose` |
| Quality bar (floor-guard) | always | none: run inline |
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

- **Standards**: first find every file that documents how code should be written; `CODING_STANDARDS.md` and `CONTRIBUTING.md` must be on the list when present. Brief: report every place the diff breaks a documented standard, citing the file and the rule. Skip what tooling enforces.
- **Spec**: several specs and none matches → ask which. Brief, verbatim: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding."
- **Quality bar**: run `bash ${CLAUDE_SKILL_DIR}/scripts/floor-guard.sh --base <base>`. Exit 1 → each `[rule] file:line` is Important unless the diff or a commit message gives the reason. Exit 2 → note the check as skipped.

### 3. Fan out

Spawn all reviewers in **one message** so they run concurrently. Each gets: repo path (note if it's a worktree), the exact diff command and its subset of files, one paragraph of context, its instruction (run the audit skill via the Skill tool — fall back to the skill's checklist if subagents can't load skills — or apply the lens), a pointer to `.specs/plans/*.md` if present, and the output contract — findings with `file:line`, severity (`critical` / `important` / `suggestion`), one-line rationale. **Read-only**: no edits, staging, commits, or pushes. Brief with the artifact and the requirements, never your own conclusion: a reviewer told what to find finds it.

**Build/install collisions**: `perf-audit` builds and `deps-audit` may touch `node_modules` — give those worktree isolation or run them serially after the read-only reviewers.

### 4. Consolidate

Merge findings, dedupe, and flag convergence (≥2 reviewers on the same line). A subagent that errors is noted as skipped, not silently dropped. Relay each reviewer's real severity — don't inflate or bury. Drop a finding only if you verified it's already handled, and say why. Standards and Spec findings stay under their own headings: never re-rank one axis against the other, since a change can pass one and fail the other.

```
## Review Summary
**Scope**: <files/lines> · **Reviewers**: <list>

### Critical (blocks merge) — correctness, security, sensitive data, WCAG A
### Important (fix before merge) — architecture friction, missing tests, known CVEs, quality bar lowered
### Suggestions — style, naming, optional perf
### Standards — each finding cites its rule, with severity
### Spec — each finding quotes its spec line, with severity
### Converged (≥2 reviewers agreed)
### Non-issues — flagged but fine, with why
```

### 5. Verdict

Count Standards and Spec findings by their severity. **APPROVE** (zero Critical, zero Important) · **REQUEST CHANGES** (any Critical, or 3+ Important) · **NEEDS DISCUSSION** (Important findings involving architectural tradeoffs). Never auto-fix.

Next: REQUEST CHANGES → fix, re-run `/review`. NEEDS DISCUSSION → settle it with the user, then re-run. APPROVE → `/ship`.
