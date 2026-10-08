---
name: architecture-audit
effort: xhigh
description: Surface architectural friction across a codebase and propose refactors toward deep modules as RFCs. Use when asked to audit architecture, find structural friction, or spot refactor opportunities. Don't use for one module's interface (/codebase-design) or a diff (/code-review).
argument-hint: '[direction] [--html]'
---

# Architecture Audit

Audit a codebase for architectural friction and propose refactors toward **deep modules** (simple interface, large implementation). Deep modules are more testable, more AI-navigable, and let you test at the seam instead of inside.

Uses the deep-module vocabulary and principles — call the Skill tool with `codebase-design` for the canonical glossary (module, interface, depth, seam, adapter, leverage, locality) and core principles (deletion test, interface-as-test-surface, one-adapter-is-hypothetical). Use those terms exactly in every suggestion. For audit-specific examples and anti-patterns (pass-through, temporal decomposition, classitis, signs a module is too shallow), see [references/deep-modules.md](references/deep-modules.md).

## Workflow

### 1. Explore

**Scope first (YAGNI).** Deepening pays off where code keeps changing. A direction in `$ARGUMENTS` (module, subsystem, pain point) → take it. Otherwise read a good stretch of `git log --oneline` for hot spots, the files and areas that keep coming up, and start there; no clear hot spot → widen the net. Read the ADRs in the area: a candidate an ADR already rejected comes back only when the friction is worth reopening it.

Use the Agent tool with subagent_type=Explore to navigate the codebase organically. Note where you experience friction:

- Understanding one concept requires bouncing between many small **modules**
- A module's **interface** is nearly as complex as its **implementation** (shallow module)
- Pure functions extracted just for testability, but real bugs hide in how they're called
- Tightly-coupled modules create integration risk at the **seams** between them
- A module fails the **deletion test** — deleting it makes complexity vanish (pass-through), or its complexity is duplicated across N callers (earning its keep but in the wrong place)
- Areas that are untested or hard to test

The friction you encounter IS the signal.

### 2. Present candidates

Show a numbered list. For each candidate:

- **Cluster**: which modules/concepts are involved
- **Why they're coupled**: shared types, call patterns, co-ownership of a concept
- **Dependency category**: from the DEEPENING reference in `codebase-design`
- **Test impact**: what existing tests would be replaced by tests at the new seam
- **Strength**: `Strong`, `Worth exploring`, or `Speculative`

`--html` → also render the candidates as a report with before/after diagrams, per [references/html-report.md](references/html-report.md).

Do NOT propose interfaces yet. Ask which candidate to explore. The user rejects one for a load-bearing reason → offer to record it (call the Skill tool with `create-adr`) so later audits don't re-suggest it. Skip ephemeral reasons ("not now").

### 3. Design the interface

For the chosen candidate, run the Design-It-Twice procedure from the DESIGN-IT-TWICE reference in `codebase-design`: frame the problem space, spawn 3+ sub-agents with radically different constraints, compare, recommend. Then ask which design to use — your recommendation first, marked (Recommended).

### 4. Write improvement PRD

Save a markdown file named `architecture-<cluster-name>.md` using the template in [references/improvement-template.md](references/improvement-template.md). If `.specs/specs/` exists, save there; otherwise, save in `specs/`.

Fill with concrete details: file paths, function names, migration steps. Share the file path with the user when done.

## Rules

- Old unit tests on shallow modules are waste once seam tests exist — note them for deletion
- Don't introduce a new seam unless something actually varies across it (one adapter = hypothetical, two = real)
- Candidate scope turns out much larger than expected → surface it and re-scope before designing
