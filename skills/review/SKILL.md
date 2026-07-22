---
name: review
effort: high
description: Orchestrated REVIEW phase — fan out parallel, read-only reviewers over a diff (scope-detected audit skills AND independent agent lenses), then consolidate into one severity-ranked verdict. Use for a full pre-ship review, "review/validate this PR", or "spawn agents to review". Don't use to implement fixes (use /build or /tdd), for a single focused audit or one-lens pass (call it directly, e.g. /a11y-audit, /code-review), or to triage existing reviewer comments (use /triage-review).
argument-hint: '[PR-number-or-branch] [agent-count]'
---

# Review Phase

Workflow orchestrator for the REVIEW phase of the SDLC. Resolve the diff, fan out **parallel read-only reviewers** — each in its own subagent (fresh context) — and consolidate everything into one severity-ranked verdict.

Reviewers come from two complementary sources; use whichever fit the change (usually both):

- **Audit skills** — deterministic by file type in the diff: `a11y-audit`, `i18n`, `perf-audit`, `deps-audit`, `harden`, `safe-repo`. *Which* run is decided by scope detection.
- **Agent lenses** — independent perspectives on the whole diff: correctness, test effectiveness, security, type safety, architecture friction.

Fanning out to subagents keeps each reviewer's work out of the main thread (no bleed between a11y and security reasoning) and runs them concurrently instead of one-after-another. Findings two reviewers reach independently are the highest signal — surface that convergence.

Sibling skills: `code-review` is a single in-thread lens; `triage-review` evaluates *existing* reviewer comments rather than generating new ones.

## Workflow

### Phase 1 — Resolve the diff

Priority order:

1. PR number passed → `gh pr view <num>` for context, `gh pr diff <num>` for the diff.
2. Branch name passed → `git diff <base>...<branch>`.
3. Nothing passed → `git merge-base HEAD main` (fall back `master`, then `origin/HEAD`), then `git diff <base>...HEAD`.

Capture the changed-file list. If the diff is empty, report "Nothing to review" and stop. State the resolved scope before spawning: "Reviewing branch `X` vs `main` — 6 files, 224 insertions."

### Phase 2 — Select reviewers

Always include: **correctness (`code-review`)**, **sensitive-data scan (`safe-repo`, diff-only)**, and **test effectiveness**. Add the rest from the diff. Default to ~3–5 reviewers total; honor an explicit count from `$ARGUMENTS` (2–5).

| Reviewer | When | Kind | Suggested agent type |
|----------|------|------|----------------------|
| Correctness & bugs (`code-review`) | always | audit skill | `general-purpose` (runs `code-review`) |
| Sensitive data (`safe-repo` diff-only) | always | audit skill | `general-purpose` |
| Test effectiveness | always | lens | `hb:test-auditor` |
| Accessibility (`a11y-audit`) | JSX/TSX/HTML/CSS changed | audit skill | `hb:frontend-architect` (or `general-purpose`) |
| User-facing strings (`i18n`) | new JSX text nodes / template literals in changed `.jsx/.tsx` | audit skill | `hb:frontend-architect` (or `general-purpose`) |
| Bundle / perf (`perf-audit`) | `package.json`, `vite/webpack/next.config.*` changed | audit skill | `general-purpose` |
| Dependencies (`deps-audit`) | `package.json` / lockfile changed | audit skill | `general-purpose` |
| Security & trust boundaries (`harden`) | `routes/`, `api/`, `controllers/`, `models/`, `*.sql`, auth/input/external calls | audit skill | `hb:security-auditor` |
| Type safety | heavy TS / type-level changes | lens | `general-purpose` |
| Architecture friction | cross-module / structural changes | lens | `hb:frontend-architect` |

Agent types are environment-specific. Match each reviewer to an **available** agent type (listed in the harness); if none fits, spawn `general-purpose` (or `Explore`) with a focused prompt. **Never invent an agent type.** Announce the chosen reviewers + agent types before spawning, and skip irrelevant ones with a one-line reason ("No frontend changes, skipping a11y-audit").

### Phase 3 — Fan out (parallel subagents)

Spawn **all reviewers in a single message** (multiple Agent calls) so they run concurrently. Give each:

- The repo path (and a note if it's a git worktree — run everything there, don't `cd` away).
- The exact diff command and the subset of changed files it cares about.
- One-paragraph context (what the change does + ticket id if known).
- Its instruction: for an audit-skill reviewer, **run that skill** via the Skill tool (fall back to the audit's checklist if skills aren't available to the subagent); for a lens reviewer, apply the lens directly.
- If a plan/spec exists (`.specs/plans/*.md`), point the test/correctness reviewers at it to check coverage against intent.
- Output contract: concise findings, each with `file:line`, a severity (`critical` / `important` / `suggestion`), a one-line rationale, and a closing summary. **Read-only** — must not modify, stage, commit, or push.

**Build/install collisions**: reviewers that mutate the working dir (`perf-audit` builds; `deps-audit` may touch `node_modules`) can clobber each other in the same checkout. Give those worktree isolation, or run them serially after the read-only ones.

### Phase 4 — Consolidate

Merge every subagent's findings into one report. Dedupe overlaps and **flag convergence** (two reviewers hitting the same line = higher signal).

```
## Review Summary

**Scope**: <files/lines changed> · **Reviewers**: <code-review (general-purpose), tests (hb:test-auditor), ...>

### Critical (blocks merge)
- <file:line> — <issue> — <which reviewer flagged it>

### Important (should fix before merge)
- <file:line> — <issue> — <reviewer>

### Suggestions (nice-to-have)
- <file:line> — <issue> — <reviewer>

### Converged (≥2 reviewers agreed)
- <issue> — <which reviewers>

### Non-issues / already resolved
- <thing a reviewer flagged that's actually fine, with why>

### Reviewers run
- code-review ✓ · safe-repo ✓ · tests ✓ · a11y-audit ✓ · ...
```

Critical = correctness, security, sensitive data, accessibility blockers (WCAG level A).
Important = readability, architecture friction, missing tests, deps with known CVEs.
Suggestions = style, naming, optional perf wins.

Drop or downgrade a finding if you can verify it's already handled — but say why.

### Phase 5 — Verdict

State explicitly: **APPROVE**, **REQUEST CHANGES**, or **NEEDS DISCUSSION**.

- APPROVE: zero Critical, zero Important
- REQUEST CHANGES: any Critical, or 3+ Important
- NEEDS DISCUSSION: Important findings that involve architectural tradeoffs

Then offer next steps (e.g. "apply the cheap test fixes? leave the design refactor as a follow-up?"). Do not auto-fix.

## Rules

- Always announce the resolved scope + chosen reviewers/agent types before spawning.
- Always spawn the reviewers in ONE message so they run in parallel.
- Always run `code-review`, `safe-repo`, and a test-effectiveness reviewer — these are non-negotiable.
- Skip irrelevant reviewers explicitly with a one-line reason.
- Match reviewers to available agent types; fall back to `general-purpose`. Never name an agent type that isn't available.
- Subagents are read-only — never let them (or you) modify, stage, commit, or push.
- Dedupe across reviewers and surface convergence — that's the benefit of fanning out.
- Consolidate faithfully — relay each reviewer's real severity; don't inflate or bury findings.
- Never invoke `e2e` or `visual-validate` — those belong to VERIFY phase, not REVIEW.
- Never auto-fix issues during review; only report.

## Error Handling

- If the diff is empty → report "Nothing to review" and stop.
- If `git merge-base` fails (no main/master/origin) → fall back to `HEAD~10`, warn the base may be wrong.
- If a PR number was passed but `gh pr <...>` fails → fall back to current-branch diff, warn the user.
- If a subagent errors or returns nothing → note the skipped reviewer in the final report and continue consolidating the rest.
