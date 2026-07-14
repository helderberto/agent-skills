---
name: validate-pr
effort: high
description: Validate a PR by fanning out independent review agents in parallel, each on a different lens, then consolidate and dedupe their findings into one verdict. Use when the user says "validate this PR", "spawn agents to review", or wants multiple independent perspectives at once. Don't use for a single-lens review (use /code-review) or sequential audit-skill orchestration (use /review).
argument-hint: '[PR-number-or-branch] [agent-count]'
---

# Validate PR (parallel agent fan-out)

Spawn several **independent review agents at once**, each looking at the same diff through a different lens, then merge their findings into a single severity-ranked verdict. Findings that multiple agents reach independently are the highest-signal — surface that convergence.

This differs from sibling skills:

- `code-review` — one review, one lens.
- `review` — runs audit **skills** sequentially in the main thread.
- `validate-pr` — runs review **agents** concurrently, then consolidates. Faster and gives independent perspectives, at the cost of more tokens.

## Workflow

### Phase 1 — Resolve the diff

Determine what to review, in priority order:

1. PR number passed → `gh pr view <num>` for context, `gh pr diff <num>` for the diff.
2. Branch name passed → `git diff <branch-base>...<branch>`.
3. Nothing passed → current branch vs its base: `git merge-base HEAD main` (fall back to `master`, then `origin/HEAD`), then `git diff <base>...HEAD`.

Capture the changed-file list and the diff. If the diff is empty, report "Nothing to validate" and stop.

State the resolved scope before spawning: "Reviewing branch `X` vs `main` — 6 files, 224 insertions."

### Phase 2 — Pick lenses

Default to **3 agents**. Honor an explicit count from `$ARGUMENTS` (2–5). Always include the first two; choose the rest from the diff:

| Lens | When | Suggested agent type |
|------|------|----------------------|
| Correctness & bugs | always | `code-reviewer` |
| Test effectiveness | always | `test-quality` (or `test-auditor`) |
| Frontend design & a11y | JSX/TSX/CSS changed | `frontend-architect` |
| Security & trust boundaries | auth, input handling, data storage, external calls, SQL | `security-auditor` |
| Type safety | heavy TS / type-level changes | `ts-enforcer` |
| Architecture friction | cross-module / structural changes | `frontend-architect` |

Agent types are environment-specific. Match the lens to an **available** agent type (listed in the harness). If none fits, spawn a `general-purpose` (or `Explore`) agent with a lens-focused prompt. Never invent an agent type.

Announce the chosen lenses + agent types before spawning.

### Phase 3 — Fan out (parallel)

Spawn all agents in a **single message** (multiple Agent tool calls) so they run concurrently. Give each agent:

- The repo path (and a note if it's a git worktree — run everything there, don't `cd` away).
- The exact diff command to run (`git diff <base>...HEAD` or `gh pr diff <num>`).
- One-paragraph PR context (what the change does + ticket id if known).
- Its specific lens and what to focus on.
- Output contract: concise findings, each with `file:line`, a severity (`blocker` / `important` / `nit`, or lens-specific like `gap` / `weak`), a one-line rationale, and a closing verdict.
- **Read-only**: must not modify, stage, commit, or push anything.

If a plan or PRD exists (`.specs/plans/*.md`), point the test/correctness agents at it so they can check coverage against intent.

### Phase 4 — Consolidate

Merge all agent outputs into one report. Dedupe overlapping findings and **flag convergence** explicitly (multiple agents → higher confidence).

```
## PR validation — N agents

**Scope**: <branch/PR, files, lines> · **Agents**: <lens (type), ...>

### Blockers
- <file:line> — <issue> — flagged by <agents>

### Important
- <file:line> — <issue> — <agent(s)>

### Nits / suggestions
- <file:line> — <issue> — <agent(s)>

### Converged (≥2 agents agreed)
- <issue> — <which agents>

### Non-issues / already resolved
- <thing an agent flagged that's actually fine, with why>
```

Drop or downgrade a finding if you can verify it's already handled — but say why.

### Phase 5 — Verdict

State one: **APPROVE** · **REQUEST CHANGES** · **NEEDS DISCUSSION**.

- APPROVE — zero blockers, zero important.
- REQUEST CHANGES — any blocker, or 3+ important.
- NEEDS DISCUSSION — important findings that are architectural tradeoffs.

Then offer next steps (e.g. "apply the cheap test/e2e fixes? leave the design refactor as a follow-up?"). Do not auto-fix.

## Rules

- Always spawn the agents in ONE message so they run in parallel.
- Agents are read-only — never let them (or you) modify, commit, or push during validation.
- Match lenses to available agent types; fall back to `general-purpose` with a focused prompt. Never name an agent type that isn't available.
- Dedupe across agents and surface convergence — that's the point of fanning out.
- Verify before repeating a finding: if it's already resolved in the diff or elsewhere, downgrade it with a reason rather than echoing it.
- Consolidate faithfully — relay each agent's real severity; don't inflate or bury findings.

## Error Handling

- Empty diff → "Nothing to validate", stop.
- `git merge-base` fails (no main/master/origin) → fall back to `HEAD~10`, warn the base may be wrong.
- `gh pr <...>` fails → fall back to current-branch diff, warn the user.
- An agent errors or returns nothing → note it as a skipped lens in the report and continue with the rest.
