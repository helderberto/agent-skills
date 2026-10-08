---
name: build
effort: high
description: Implement the next unblocked phase of a plan with feedback loops, mark its checkboxes, offer a commit. Use after /plan when `.specs/plans/<slug>.md` exists, or when asked to build the next phase. Don't use for unplanned changes (/tdd) or to check progress (/test).
argument-hint: '[slug] [--all]'
---

# Build Phase

Implement the next incomplete phase of a plan — one phase per invocation. `--all` runs every remaining phase after one approval ([below](#--all)).

## Input

`$ARGUMENTS` is a `<slug>` or an `@path` (read that file directly as the plan). If empty or the plan is missing, list `.specs/plans/*.md` as numbered options and wait.

## Workflow

### 1. Find the next incomplete phase

Scan `## Phase N` headings and count `- [ ]` / `- [x]`. The next incomplete phase is the first with an unchecked item **and** whose `**Blocked by**` phases (if declared) are all complete. If the first incomplete phase is blocked, pick the next unblocked one and say why.

All phases complete → "All phases complete. Run `/test <slug>` to verify." Stop.

### 2. Present the phase

Show the title and unchecked items. If on the default branch, offer to create `feat/<slug>` (Recommended) before touching code.

### 3. Implement

For each unchecked item, in order: read the plan's architectural decisions and the item's context, explore the surrounding code, and follow the project's conventions (CLAUDE.md, linter, test setup). Call the Skill tool with `tdd` at the phase's seams — the ones its Done-when items name. Completion: every item's test went red before it went green.

Stay inside the phase boundary — never implement items from other phases. Never impose conventions the project doesn't already use.

### 4. Feedback loops

Call the Skill tool with `validate-code` (auto-fix on). Fix and re-run until green. A check still failing after 3 attempts is a **blocker**: report the last error and ask whether to wait, skip the check, or abort the phase.

Anything the agent cannot provide (API key, external service, manual setup, design decision) is also a blocker — ask, never work around it silently.

### 5. Mark checkboxes

Flip completed items `- [ ]` → `- [x]` in the plan. This is the only plan edit; the spec is read-only.

### 6. Summarize

```text
CHANGES MADE:
- <file>: <what changed>
THINGS I DIDN'T TOUCH:
- <file or area>: <why it stayed out of scope>
POTENTIAL CONCERNS:
- <assumption or risk to confirm>
```

### 7. Offer commit

"Phase N complete — all checks pass. Commit?" If yes, call the Skill tool with `commit`, passing the phase's files (`.specs/` only when the project commits specs). Never push. Then: "Run `/build <slug>` for Phase N+1, or `/test <slug>` to verify."

## `--all`

Steps 1–7 for every remaining phase, with one human gate up front:

1. A plan must exist. No plan → point at `/plan <slug>` and stop.
2. `git status --porcelain` must be clean apart from `.specs/`. Anything else → ask the user to commit, stash, or confirm. Per-phase commits never absorb unrelated work.
3. Present every remaining phase and wait for an unambiguous yes ("go", "approve", "yes"). Hedged answers ("looks reasonable", "I guess") are not approval. This approval also covers `tdd`'s seam confirmation for each phase.
4. Run the phases in blocking order. Commit each phase without asking, scoped to that phase's files — never `git add -A`.
5. Stop and ask when a check stays red after 3 fixes, the spec is ambiguous or silent on a needed decision, or a phase does something `git revert` can't undo: auth or permission changes, destructive migrations, payments, deletes, deploys, secrets. Rerunning `/build <slug> --all` resumes at the next pending phase.
6. End with a summary: phases completed, tests added, commits made, anything skipped or flagged.
