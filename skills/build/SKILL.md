---
name: build
effort: high
description: Implement the next unblocked ticket test-first, mark its checkboxes, and commit.
disable-model-invocation: true
argument-hint: '[slug] [--all]'
---

# Build

Implement the next unblocked ticket from `.specs/tickets/<slug>.md` — one ticket per invocation. `--all` runs every remaining ticket after one approval ([below](#--all)).

## Input

`$ARGUMENTS` is a `<slug>` or an `@path` (read that file directly as the tickets file). If empty or the file is missing, list `.specs/tickets/*.md` as numbered options and wait.

Free text from `triage` (an S change: one commit, no tickets) → call the Skill tool with `tdd` for it, regression test first for a bug. Then run steps 4, 6, and 7 as one ticket with one commit, and end with `Next: /hb:review`.

## Workflow

### 1. Find the next unblocked ticket

Scan `## Ticket N` headings and count `- [ ]` / `- [x]`. The next ticket is the first with an unchecked item **and** whose `**Blocked by**` tickets (if declared) are all complete. If the first incomplete ticket is blocked, pick the next unblocked one and say why.

All tickets complete → "All tickets complete." Stop with `Next: /hb:review`.

### 2. Present the ticket

Show the title, its `hitl` label if any, and unchecked items. If on the default branch, offer to create `feat/<slug>` (Recommended) before touching code.

### 3. Implement

For each unchecked item, in order: read the file's architectural decisions and the item's context, explore the surrounding code, and follow the project's conventions (CLAUDE.md, linter, test setup). Call the Skill tool with `tdd` at the ticket's seams — the ones its acceptance criteria name. Completion: every item's test went red before it went green.

Stay inside the ticket boundary — never implement items from other tickets. Never impose conventions the project doesn't already use.

### 4. Feedback loops

Call the Skill tool with `check` (auto-fix on). Fix and re-run until green. A check still failing after 3 attempts is a **blocker**: report the last error and ask whether to wait, skip the check, or abort the ticket.

Anything the agent cannot provide (API key, external service, manual setup, design decision) is also a blocker — ask, never work around it silently.

### 5. Mark checkboxes

Flip completed items `- [ ]` → `- [x]` in the tickets file. This is the only tickets edit; the spec is read-only.

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

"Ticket N complete — all checks pass. Commit?" If yes, call the Skill tool with `commit`, passing the ticket's files (`.specs/` only when the project commits specs). Never push.

Next: `/hb:build <slug>` for Ticket N+1, or `/hb:review` once every ticket is done.

## `--all`

Steps 1–7 for every remaining ticket, with one human gate up front:

1. A tickets file must exist. None → stop with `Next: /hb:to-tickets <slug>`.
2. `git status --porcelain` must be clean apart from `.specs/`. Anything else → ask the user to commit, stash, or confirm. Per-ticket commits never absorb unrelated work.
3. Present every remaining ticket and wait for an unambiguous yes ("go", "approve", "yes"). Hedged answers ("looks reasonable", "I guess") are not approval. This approval also covers `tdd`'s seam confirmation for each ticket.
4. Run the tickets in blocking order. Commit each ticket without asking, scoped to that ticket's files — never `git add -A`.
5. Stop and ask before a `hitl` ticket, when a check stays red after 3 fixes, the spec is ambiguous or silent on a needed decision, or a ticket does something `git revert` can't undo: auth or permission changes, destructive migrations, payments, deletes, deploys, secrets. Rerunning `/hb:build <slug> --all` resumes at the next pending ticket.
6. End with a summary: tickets completed, tests added, commits made, anything skipped or flagged.
