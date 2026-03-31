---
name: prd-to-plan
description: Convert a PRD into a phased implementation plan saved to plans/<name>.md. Use when user has a PRD (from write-a-prd) and wants a concrete execution plan with phases, tasks, and done criteria. Don't use for refactoring plans (use refactor-plan) or when no PRD exists yet.
---

# PRD to Plan

## Pre-loaded context

- Available PRDs: !`ls prds/ 2>/dev/null || echo "no prds/ directory found"`

## Workflow

### 1. Read the PRD
Open the PRD file the user referenced (e.g. `prds/<name>.md`). If no name given, list available PRDs and ask which one to use.

### 2. Interview
Ask exactly two questions, one at a time. Lead with a recommended answer based on PRD content.

1. **Phase strategy** — recommend a strategy based on PRD structure (see [references/phase-strategy.md](references/phase-strategy.md)); confirm or let user choose.
2. **Constraints** — any hard deadlines, must-ship-first phases, or team limits?

### 3. Derive phases
Map PRD sections to phases ordered by dependency. Each phase needs: goal, task checklist, done-when condition. See [references/phase-strategy.md](references/phase-strategy.md).

### 4. Save plan
Use [assets/template.md](assets/template.md). Save to `plans/<same-stem-as-prd>.md`. Create `plans/` directory if missing.

### 5. Report
Print the saved path and one line per phase: `Phase N — <goal> (<N> tasks)`.

## Rules

- Tasks must be derived from PRD User Stories or Implementation Decisions — never invented
- Each task starts with a verb: Implement, Add, Write, Extract, Wire
- Done-when conditions must be testable, not vague
- Never modify the source PRD
- Carry PRD's Out of Scope section forward verbatim

## Error Handling

- PRD not found → list available PRDs and ask user to confirm
- PRD missing key sections → note gaps inline and continue
- `plans/` missing → create it before writing
- User skips interview → default to layer-by-layer strategy

## See Also

- [write-a-prd](../write-a-prd/SKILL.md) — produces the PRD this skill consumes
