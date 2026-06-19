---
name: build
description: Implement one phase of a plan. Reads plan, finds next incomplete phase, implements it, runs feedback loops, marks checkboxes, offers commit. One phase per invocation. Use when the user wants to implement, code, build, or work on the next phase of a plan.
argument-hint: '[slug]'
---

# Build Phase

Implement the next incomplete phase of a plan — one phase per invocation.

**Context window**: recommend `/clear` before starting to maximize token budget.

**Interactive prompts**: present options as a numbered list and wait for the user's choice.

## Input

The argument (if provided) is: $ARGUMENTS

Use argument as `<slug>`. If empty, list plans as numbered options and wait for the user's choice.

Accepts slug or `@file` reference:

```
/build dark-mode-support
/build @.specs/plans/dark-mode-support.md
```

If argument starts with `@`, treat it as a file path — read that file directly as the plan.

## Workflow

### 1. Load the plan

Read `.specs/plans/<slug>.md`. If missing, list plans as numbered options and wait for the user's choice.

### 2. Find the next incomplete phase

Scan the plan for `## Phase N` headings. For each phase, count `- [ ]` and `- [x]` checkboxes.

The **next incomplete phase** is the first phase that has at least one unchecked `- [ ]` item.

If all phases are complete (zero unchecked items across all phases):

> All phases complete. Run `/verify-plan <slug>` to verify.

Stop here.

### 3. Present the phase

Show the phase title and its unchecked items:

```
Phase N — <title> (M remaining)
- [ ] First unchecked item
- [ ] Second unchecked item
```

### 4. Offer a feature branch

If on the default branch (main/master), ask:

> Create branch `feat/<slug>`?
>
> 1. Yes, create branch (Recommended)
> 2. No, stay on current branch

If accepted, create and switch to the branch.

If already on a feature branch, skip this step.

### 5. Implement the phase

Work through each unchecked item in order. For each item:

1. Read the plan's architectural decisions and the current item's context
2. Explore relevant code to understand existing patterns and conventions
3. Implement the change — follow the project's conventions (CLAUDE.md, linter config, test setup)
4. Write tests alongside implementation (follow the project's existing test patterns)

**Do not** impose coding rules, style, or conventions. Follow what the project already uses.

**Do not** implement items from other phases. Stay within the current phase boundary.

### 6. Run feedback loops

After implementing the phase, detect and run available project scripts. Check `package.json` for these scripts (run only what exists):

| Script pattern                     | Purpose       |
| ---------------------------------- | ------------- |
| `typecheck`, `tsc`, `type-check`   | Type checking |
| `test`, `vitest`, `jest`           | Tests         |
| `lint`, `eslint`                   | Linting       |
| `format:check`, `prettier --check` | Formatting    |

Run each detected script. If any fails:

1. Read the error output
2. Fix the issue
3. Re-run the failing script
4. Repeat until all pass (max 3 attempts per script)

If a script still fails after 3 attempts, treat it as a **blocker** — pause and ask the user for help:

> **Blocker**: `<script>` fails after 3 attempts.
> Last error: `<error summary>`
>
> How to proceed?
>
> 1. I'll fix it — pause and wait
> 2. Skip this check and continue
> 3. Abort this phase

Wait for the user's response before continuing.

### 7. Mark checkboxes

After all feedback loops pass, for each completed item change `- [ ]` → `- [x]` in `.specs/plans/<slug>.md`.

### 8. Offer commit

Present the changes and ask:

> Phase N complete — all checks pass. Commit?
>
> 1. Yes, commit
> 2. No, I'll review first

If the user chooses to commit:

1. Stage the implementation files (not `.specs/` artifacts unless the project dogfoods TracerKit)
2. Create a commit with a message following the project's commit conventions
3. Confirm: "Committed. Run `/build <slug>` for Phase N+1, or `/verify-plan <slug>` to verify."

If the user chooses to review:

> Ready for review. Run `/build <slug>` again when ready to continue.

### 9. Blockers during implementation

If implementation requires something the agent cannot provide (API key, external service, manual setup, design decision):

> **Blocker**: <description of what's needed>
>
> How to proceed?
>
> 1. I've resolved it — continue
> 2. Skip this item for now
> 3. Abort this phase

Wait for the user's response. Never guess or work around a blocker silently.

## Rules

- **One phase per invocation** — never auto-advance to the next phase
- **Never modify PRD content** — the PRD is read-only
- **Never modify plan content** beyond marking checkboxes `[x]`
- **Never skip a phase** — phases must be completed in order
- **Never impose conventions** — follow the project's existing setup
- **HITL at every decision point** — commits, blockers, and branch creation require user approval
- **Feedback loops are mandatory** — always run available checks before marking items complete
- **Do not push to remote** — only commit locally
