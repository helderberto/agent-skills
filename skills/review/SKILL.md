---
name: review
effort: high
description: Orchestrated REVIEW phase — detect which audits apply from the diff, run each in its own parallel subagent (fresh context), then consolidate findings by severity. Use for a full pre-ship review or when the user asks to run all relevant audits on changes or a PR. Don't use to implement fixes (use /build or /tdd), for a single focused audit (call it directly, e.g. /a11y-audit, /code-review), or for independent parallel-agent perspectives on one PR (use /validate-pr).
argument-hint: '[PR-number-or-branch]'
---

# Review Phase

Workflow orchestrator for the REVIEW phase of the SDLC. Decides **which audits apply** based on the diff, then runs each applicable audit in its **own subagent** — fresh context, in parallel — and consolidates everything into one severity-ranked verdict.

Fanning out to subagents keeps each audit's work out of the main thread's context (no bleed between a11y and security reasoning) and runs them concurrently instead of one-after-another.

This differs from sibling skills:

- `code-review` — one review, one lens, in-thread.
- `validate-pr` — parallel agents each applying an independent **lens/perspective** to the whole diff.
- `review` — parallel subagents each running a **scope-detected audit skill** (a11y, i18n, perf, deps, harden, code-review, safe-repo). Skill-driven and deterministic about *which* audits run; validate-pr is perspective-driven.

## Workflow

### Phase 1 — Scope detection

Resolve the diff first (PR number → `gh pr diff <num>`; branch → `git diff <base>...<branch>`; nothing → `git merge-base HEAD main`, fall back `master`/`origin/HEAD`, then `git diff <base>...HEAD`). Capture the changed-file list.

From the diff, classify changed files:

| Category | Detection | Audit skill |
|----------|-----------|-------------|
| Frontend (JSX/TSX/HTML/CSS) | `\.(jsx?\|tsx?\|html\|css\|scss)$` matches | `a11y-audit` |
| User-facing strings | Strings added in components | `i18n` |
| Bundle / build output | `package.json`, `vite.config.*`, `webpack.config.*`, `next.config.*` | `perf-audit` |
| Dependencies | `package.json` / `package-lock.json` changed | `deps-audit` |
| Any code change | always | `code-review` |
| Any code change | always | `safe-repo` (diff-only mode) |
| Backend API / data handling | `routes/`, `api/`, `controllers/`, `models/`, `*.sql` | `harden` |

Announce the detected scope and which audits will fan out **before** spawning: "Detected frontend + dependency changes. Fanning out: code-review, safe-repo, a11y-audit, deps-audit."

### Phase 2 — Fan out (parallel subagents)

Spawn **one subagent per applicable audit, all in a single message** so they run concurrently. Give each subagent:

- The repo path (and a note if it's a git worktree — run everything there, don't `cd` away).
- The exact diff command and the subset of changed files its audit cares about (a11y → changed JSX/HTML; perf → build config; etc.).
- One-paragraph context (what the change does + ticket id if known).
- Its instruction: **run the corresponding audit skill** via the Skill tool (e.g. invoke `a11y-audit` on the listed files). If skills aren't available to the subagent in this environment, apply that audit's checklist directly.
- Output contract: concise findings, each with `file:line`, a severity (`critical` / `important` / `suggestion`), a one-line rationale, and a closing summary. **Read-only** — must not modify, stage, commit, or push.

Pick each subagent's **agent type** by matching the audit to an *available* type (listed in the harness); fall back to `general-purpose` with an audit-focused prompt. Never invent an agent type. Suggested mapping:

| Audit skill | Suggested agent type |
|-------------|----------------------|
| `code-review` | `code-reviewer` |
| `harden` | `security-auditor` |
| `a11y-audit` / `perf-audit` / `i18n` | `frontend-architect` (or `general-purpose`) |
| `deps-audit` / `safe-repo` | `general-purpose` |

Announce the chosen audits + agent types before spawning.

**Build/install collisions**: audits that mutate the working dir (`perf-audit` builds the bundle, `deps-audit` may touch `node_modules`) can clobber each other if run concurrently in the same checkout. Give those worktree isolation, or run them serially after the read-only audits.

### Phase 3 — Consolidate

Merge every subagent's findings into one report. Dedupe overlaps and **flag convergence** (if two audits independently hit the same line, that's higher signal).

```
## Review Summary

**Scope**: <files/lines changed> · **Audits**: <a11y-audit (frontend-architect), ...>

### Critical (blocks merge)
- <file:line> — <issue> — <which audit flagged it>

### Important (should fix before merge)
- <file:line> — <issue> — <audit>

### Suggestions (nice-to-have)
- <file:line> — <issue> — <audit>

### Converged (≥2 audits agreed)
- <issue> — <which audits>

### Audits run
- code-review ✓
- safe-repo ✓
- a11y-audit ✓
- ...
```

Critical = correctness, security, sensitive data, accessibility blockers (level A WCAG).
Important = readability, architecture friction, missing tests, deps with known CVEs.
Suggestions = style, naming, optional perf wins.

Drop or downgrade a finding if you can verify it's already handled — but say why.

### Phase 4 — Verdict

State explicitly: **APPROVE**, **REQUEST CHANGES**, or **NEEDS DISCUSSION**.

- APPROVE: zero Critical, zero Important
- REQUEST CHANGES: any Critical, or 3+ Important
- NEEDS DISCUSSION: Important findings that involve architectural tradeoffs

## Rules

- Always announce the detected scope + chosen audits/agent types before spawning.
- Always spawn the audit subagents in ONE message so they run in parallel.
- Always run `code-review` and `safe-repo` — these are non-negotiable.
- Skip irrelevant audits explicitly with a one-line reason ("No frontend changes, skipping a11y-audit").
- Match audits to available agent types; fall back to `general-purpose`. Never name an agent type that isn't available.
- Subagents are read-only — never let them (or you) modify, stage, commit, or push.
- Dedupe across audits and surface convergence — that's a benefit of the fan-out.
- Never invoke `e2e` or `visual-validate` — those belong to VERIFY phase, not REVIEW.
- Never auto-fix issues during review; only report.

## Error Handling

- If diff is empty → report "Nothing to review" and stop.
- If `git merge-base` fails (no main remote) → fall back to `HEAD~10`, warn user that base may be wrong.
- If PR number passed but `gh pr view <num>` fails → fall back to current branch diff, warn user.
- If a subagent errors or returns nothing → note the skipped audit in the final report and continue consolidating the rest.
