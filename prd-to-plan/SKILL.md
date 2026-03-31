---
name: prd-to-plan
description: Turn a PRD into a multi-phase implementation plan using tracer-bullet vertical slices, saved as a local Markdown file in ./plans/. Use when user wants to break down a PRD, create an implementation plan, plan phases from a PRD, or mentions "tracer bullets". Don't use for refactoring plans (use refactor-plan) or when no PRD exists yet.
---

# PRD to Plan

Break a PRD into a phased implementation plan using vertical slices (tracer bullets). Output is a Markdown file in `./plans/`.

## Pre-loaded context

- Available PRDs: !`ls prds/ 2>/dev/null || echo "no prds/ directory found"`

## Workflow

### 1. Read the PRD
Open the PRD file the user referenced (e.g. `prds/<name>.md`). If no name given, list available PRDs and ask which one to use.

### 2. Explore the codebase
If not already explored, read the codebase to understand current architecture, existing patterns, and integration layers.

### 3. Identify durable architectural decisions
Before slicing, identify high-level decisions unlikely to change throughout implementation:

- Route structures / URL patterns
- Database schema shape
- Key data models
- Authentication / authorization approach
- Third-party service boundaries

These go in the plan header so every phase can reference them.

### 4. Draft vertical slices
Break the PRD into **tracer bullet** phases. Each phase is a thin vertical slice that cuts through ALL integration layers end-to-end, not a horizontal slice of one layer.

- Each slice delivers a narrow but complete path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
- Do NOT include specific file names, function names, or implementation details likely to change
- DO include durable decisions: route paths, schema shapes, data model names
- Map each phase to the user stories from the PRD it addresses

### 5. Quiz the user
Present the proposed breakdown as a numbered list. For each phase show:

- **Title**: short descriptive name
- **User stories covered**: which PRD user stories this addresses

Ask the user:
- Does the granularity feel right? (too coarse / too fine)
- Should any phases be merged or split?

Iterate until the user approves the breakdown.

### 6. Save plan
Save to `plans/<same-stem-as-prd>.md`. Create `plans/` if missing. Use this template:

```markdown
# Plan: <Feature Name>

> Source PRD: <brief identifier or file path>

## Architectural decisions

Durable decisions that apply across all phases:

- **Routes**: ...
- **Schema**: ...
- **Key models**: ...

---

## Phase 1: <Title>

**User stories**: <list from PRD>

### What to build

A concise description of this vertical slice — end-to-end behavior, not layer-by-layer implementation.

### Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

---

<!-- Repeat for each phase -->
```

### 7. Report
Print the saved path and one line per phase: `Phase N — <title> (<N> acceptance criteria)`.

## Rules

- Phases must be derived from PRD user stories — never invented
- Each phase must be demoable or verifiable end-to-end on its own
- Acceptance criteria must be testable, not vague
- Never modify the source PRD
- Carry PRD's Out of Scope section forward verbatim

## Error Handling

- PRD not found → list available PRDs and ask user to confirm
- PRD missing key sections → note gaps inline and continue
- `plans/` missing → create it before writing

## See Also

- [write-a-prd](../write-a-prd/SKILL.md) — produces the PRD this skill consumes
