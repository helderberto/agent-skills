---
name: build
effort: high
description: Implement the next unblocked ticket test-first and commit it, or fan every ticket out to parallel subagents with `--all`.
disable-model-invocation: true
argument-hint: '[slug] [--all]'
---

# Build

Implement the next unblocked ticket — one ticket per invocation. `--all` fans every remaining ticket out to implementer subagents after one approval ([below](#--all)).

## Input

**Tracker**: follow `.specs/issue-tracker.md`, else [the local default](../setup/issue-tracker-local.md), for where specs and tickets live and when a ticket is done.

`$ARGUMENTS` is the spec ref (or an `@path` to a tickets file). Empty → ask for it.

Free text (an S change: one commit, no tickets) → on the default branch, offer `feat/<slug>` first, as in step 2. Then call the Skill tool with `tdd` for it, regression test first for a bug, run steps 4, 6, and 7 as one ticket with one commit, and end with `Next: /hb:review`.

## Workflow

### 1. Find the next unblocked ticket

Read the spec's tickets from the tracker. The next ticket is the first not done **and** whose blockers (if declared) are all done. If the first incomplete ticket is blocked, pick the next unblocked one and say why.

All tickets complete → "All tickets complete." Stop with `Next: /hb:review`.

### 2. Present the ticket

Show the title, its `hitl` label if any, and unchecked items. If on the default branch, offer to create `feat/<slug>` (Recommended) before touching code.

### 3. Implement

For each unchecked item, in order: read the architectural decisions and the item's context, explore the surrounding code, and follow the project's conventions (CLAUDE.md, linter, test setup). Call the Skill tool with `tdd` at the ticket's seams — the ones its acceptance criteria name. Completion: every item's test went red before it went green.

Stay inside the ticket boundary — never implement items from other tickets. Never impose conventions the project doesn't already use.

### 4. Feedback loops

Call the Skill tool with `check` (auto-fix on). Fix and re-run until green. A check still failing after 3 attempts is a **blocker**: report the last error and ask whether to wait, skip the check, or abort the ticket.

Anything the agent cannot provide (API key, external service, manual setup, design decision) is also a blocker — ask, never work around it silently.

### 5. Mark checkboxes

Tick the completed items' boxes in the tracker. This is the only tickets edit; the spec is read-only.

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

"Ticket N complete — all checks pass. Commit?" If yes, call the Skill tool with `commit`, passing the ticket's files (`.specs/` only when the project commits specs) and the tracker's commit ref, if any. Then close the ticket the tracker's way. Never push.

Next: `/hb:build <slug>` for Ticket N+1, or `/hb:review` once every ticket is done.

## `--all`

Every remaining ticket after one approval, fanned out to **implementer subagents** across the ready **frontier**. The tickets are a **task graph**, not a list of steps: the frontier is every unchecked ticket whose blockers are all done.

### Gate

1. Read the spec's tickets from the tracker. None → stop with `Next: /hb:to-tickets <spec ref>`.
2. `git status --porcelain` must be clean apart from `.specs/`. Anything else → ask the user to commit, stash, or confirm. Merges never absorb unrelated work.
3. Present the task graph (every remaining ticket, its blocked-by edges, its `hitl` label, the first frontier) and wait for an unambiguous yes ("go", "approve", "yes"). Hedged answers ("looks reasonable", "I guess") are not approval. This approval also covers `tdd`'s seam confirmation for each ticket.

### Orchestrate

You are the orchestrator. You own the **integration branch** and the tickets file, and you write no feature code.

4. **Integration branch**: the current branch, or `feat/<slug>` when on the default branch.
5. **Explore** (optional): tickets that need codebase or docs exploration → one Explore subagent saves notes to `<tmpdir>/build-<slug>/notes.md`, outside the repo, so implementers build instead of explore.
6. **Fan out**: spawn one general-purpose implementer per frontier ticket, all in one message, in the background, each in its own git worktree (`isolation: worktree`) on branch `build/<slug>-<n>`. Brief with **context pointers**, never copies: the spec and ticket refs, the spec, and the notes, plus the integration branch name. `.specs/` is often gitignored, so a worktree lacks it. Each implementer:
   - confirms its worktree is based on the integration branch tip, and resets onto it if not; installs dependencies if the worktree lacks them;
   - calls the Skill tool with `tdd` for its ticket's acceptance criteria, then with `check`, then with `commit` with the tracker's commit ref, one skill per call;
   - merges the integration branch tip into its branch before reporting;
   - never ticks boxes or closes tickets, and reports in a few lines: branch, commits, which criteria hold.
7. **Merge**: as each implementer reports, merge its branch into the integration branch. A conflict → a merger subagent resolves it there and runs `check`. Then tick its boxes and close it the tracker's way.
8. **Refill**: a merge that unblocks tickets → spawn implementers for the new frontier at once, without waiting for the rest of the wave.
9. **Stop and ask** before spawning a `hitl` ticket, when an implementer reports a check still red after 3 fixes, when the spec is ambiguous or silent on a needed decision, or when a ticket does something `git revert` can't undo: auth or permission changes, destructive migrations, payments, deletes, deploys, secrets. Running implementers keep going. Rerunning `/hb:build <slug> --all` resumes at the current frontier.

### Close

10. All tickets done → review the integration branch against its base along [code-review's axes](../code-review/references/axes.md) and [smells](../code-review/references/smells.md). One implementer fixes the Critical findings and Suggestions; list the rest.
11. Remove every implementer worktree and merged `build/<slug>-*` branch.
12. Summarize: tickets completed, tests added, merges made, anything skipped or flagged. End with `Next: /hb:review`.

No subagent support → run [the workflow](#workflow) per ticket in blocking order instead, committing each without asking, scoped to that ticket's files, never `git add -A`.
