---
name: plan
description: Turn a PRD into a multi-phase implementation plan using tracer-bullet vertical slices. Use after /prd when a PRD exists at `.specs/prds/<slug>.md`, or when the user asks to break work into phases or slices. Don't use without a PRD, or for single-file changes with obvious scope.
argument-hint: '[slug]'
---

# PRD to Plan

Break a PRD into phased vertical slices (tracer bullets).

**Interactive prompts**: present options as a numbered list and wait for the user's choice.

Output: `.specs/plans/<slug>.md`.

## Input

The argument (if provided) is: $ARGUMENTS

Use argument as `<slug>`. If empty, list PRDs as numbered options and wait for the user's choice.

## Workflow

### 1. Read the PRD

Read `.specs/prds/<slug>.md`. If missing, list PRDs as numbered options and wait for the user's choice.

If `.specs/plans/<slug>.md` exists, present options and wait:

1. Overwrite existing (Recommended)
2. Pick a new name

### 2. Explore the codebase

Map architecture, patterns, integration points. Skip if codebase context exists from prior step.

**Research protocol**: codebase first, then docs. Unverifiable claims → flag as uncertain, never fabricate.

### 3. Identify durable architectural decisions

Before slicing, extract decisions that hold across all phases:

- Route structures / URL patterns
- Database schema shape
- Key data models and definitions
- Auth/authorization approach
- Third-party service boundaries

### 4. Draft vertical slices

Each phase: thin vertical slice through all layers (schema → service → API → UI → tests). Demoable alone.

**Deriving tasks from the PRD:**

| PRD Section       | Becomes                                          |
| ----------------- | ------------------------------------------------ |
| New Modules       | Implement module with interface                  |
| Schema Changes    | Migration + validation                           |
| API Contracts     | Route returning shape                            |
| Navigation        | Wire component to route                          |
| User Stories      | Verify coverage; add task if missing             |
| Testing Decisions | Tests land in the phase where their module lands |
| Out of Scope      | Never create tasks for these                     |

**Within each slice, order by dependency:** schema → service → API → UI → tests. Happy paths before edge cases.

**Phase naming:** use a goal phrase answering "what can we demo when this is done?" (e.g., "Phase 1 — Revenue visible end-to-end"), not a layer name.

**Done when:** checkbox list of atomic, verifiable conditions. Each must name a test file/name, a shell command, or a file+content to verify. No prose-only conditions. Test: "Can an agent verify by reading files, running a command, or checking a test?"

**Layer-by-layer exception:** if complex schema changes underpin all modules and no story stands alone, build data foundation first, then slice vertically.

**Phase count thresholds:**

- 1 module touched → 2–3 phases max
- 2–3 modules touched → 3–5 phases max
- 4+ modules or 6+ phases → stop and present options:
  1. Split the PRD (Recommended)
  2. Continue anyway

Count "modules touched" by scanning the PRD's New Modules and Schema Changes sections.

Assign an agent tag to tasks where appropriate:

- `[agent:debugger]` — tracing a bug or unexpected runtime behavior
- `[agent:test-auditor]` — writing or reviewing tests
- `[agent:code-reviewer]` — reviewing API surfaces, interfaces, or public contracts

### 5. Quiz the user

Present breakdown (title, user stories covered, done-when per phase). Present options and wait:

1. Looks good, proceed (Recommended)
2. Merge some phases
3. Split a phase

Iterate until approved.

### 6. Save plan

Save to `.specs/plans/<slug>.md` (create dir if missing).

```markdown
# Plan: <Feature Name>
```

Use this structure for the plan body:

```markdown
## Architectural Decisions

Durable decisions that apply across all phases:

- **Key decision**: ...

---

## Phase 1 — <Goal>

**User stories**: <list from PRD>

### What to build

Concise description of this vertical slice — end-to-end behavior, not layer-by-layer.

### Done when

- [ ] Atomic, testable condition
- [ ] Another testable condition

---

<!-- Repeat for each phase -->

## Out of Scope

Carried forward from PRD verbatim.

## Open Questions

Gaps found in the PRD needing resolution. Blank if none.
```

Print one line per phase: `Phase N — <title> (<condition summary>)`. Present options and wait:

1. Run `/build <slug>` (Recommended)
2. Run `/verify-plan <slug>`
3. Done for now

## Execution guidance

To implement this plan phase by phase, run `/build <slug>`. It handles branch creation, implementation, feedback loops, checkbox marking, and commits — one phase per invocation.

## Rules

- Phases derive from PRD user stories — never invented
- Each phase must be demoable end-to-end on its own
- "Done when" must be a checkbox list of testable conditions, not prose
- **Safety valve**: if a phase has >5 "Done when" items, stop and split it into smaller phases before continuing
- Never modify the source PRD content
- Carry PRD's Out of Scope forward verbatim
