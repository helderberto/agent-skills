---
name: review
description: Orchestrated REVIEW phase — analyze the diff, decide which audits apply, run them in order, consolidate findings. Use for a full pre-ship review or when the user asks to run all relevant audits on changes or a PR. Don't use to implement fixes (use /build or /tdd) or for a single focused audit (call it directly, e.g. /a11y-audit, /code-review).
argument-hint: '[PR-number-or-branch]'
---

# Review Phase

Workflow orchestrator for the REVIEW phase of the SDLC. Decides **which audits apply** based on the diff and runs them through dedicated skills. Reports a single consolidated review categorized by severity.

This is a **workflow-guided** skill: it does not auto-invoke other skills silently. It announces which skill comes next, runs it, then moves to the next.

## Workflow

### Phase 1 — Scope detection

From the diff, classify changed files:

| Category | Detection | Audit to invoke |
|----------|-----------|-----------------|
| Frontend (JSX/TSX/HTML/CSS) | `\.(jsx?\|tsx?\|html\|css\|scss)$` matches | `a11y-audit` |
| User-facing strings | Strings added in components | `i18n` |
| Bundle / build output | `package.json`, `vite.config.*`, `webpack.config.*`, `next.config.*` | `perf-audit` |
| Dependencies | `package.json` / `package-lock.json` changed | `deps-audit` |
| Any code change | always | `code-review` |
| Any code change | always | `safe-repo` (diff-only mode) |
| Backend API / data handling | `routes/`, `api/`, `controllers/`, `models/`, `*.sql` | `harden` |

State the detected scope before running: "I detected frontend + dependency changes. Will run: code-review, a11y-audit, deps-audit, safe-repo."

### Phase 2 — Run audits

For each applicable audit, in this order:

1. **Always**: invoke [code-review](../code-review/SKILL.md). Five-axis review (correctness, readability, architecture, security, performance).
2. **Always**: invoke [safe-repo](../safe-repo/SKILL.md) scoped to the diff only.
3. **If frontend changes**: invoke [a11y-audit](../a11y-audit/SKILL.md) on the changed JSX/HTML files.
4. **If user-facing strings**: invoke [i18n](../i18n/SKILL.md) on the changed components.
5. **If bundle/build changes**: invoke [perf-audit](../perf-audit/SKILL.md).
6. **If dependency changes**: invoke [deps-audit](../deps-audit/SKILL.md).
7. **If backend/data handling**: invoke [harden](../harden/SKILL.md).

Announce each step before running ("Now running a11y-audit on 3 changed components..."). Capture findings per audit.

### Phase 3 — Consolidate

Merge all findings into a single report categorized by severity:

```
## Review Summary

**Scope**: <files/lines changed, audits run>

### Critical (blocks merge)
- <file:line> — <issue> — <which audit flagged it>

### Important (should fix before merge)
- <file:line> — <issue> — <audit>

### Suggestions (nice-to-have)
- <file:line> — <issue> — <audit>

### Audits run
- code-review ✓
- safe-repo ✓
- a11y-audit ✓
- ...
```

Critical = correctness, security, sensitive data, accessibility blockers (level A WCAG).
Important = readability, architecture friction, missing tests, deps with known CVEs.
Suggestions = style, naming, optional perf wins.

### Phase 4 — Verdict

State explicitly: **APPROVE**, **REQUEST CHANGES**, or **NEEDS DISCUSSION**.

- APPROVE: zero Critical, zero Important
- REQUEST CHANGES: any Critical, or 3+ Important
- NEEDS DISCUSSION: Important findings that involve architectural tradeoffs

## Rules

- Always announce which skill comes next before invoking it (workflow-guided, not silent orchestration)
- Always run `code-review` and `safe-repo` — these are non-negotiable
- Skip irrelevant audits explicitly with a one-line reason ("No frontend changes, skipping a11y-audit")
- Never invoke `e2e` or `visual-validate` — those belong to VERIFY phase, not REVIEW
- Never auto-fix issues during review; only report
- Never push, commit, or merge — review is read-only

## Error Handling

- If diff is empty → report "Nothing to review" and stop
- If `git merge-base` fails (no main remote) → fall back to `HEAD~10`, warn user that base may be wrong
- If an individual audit skill errors → log the error, continue with remaining audits, note skipped audit in the final report
- If PR number passed but `gh pr view <num>` fails → fall back to current branch diff, warn user
