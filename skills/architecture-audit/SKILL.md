---
name: architecture-audit
effort: xhigh
description: Surface architectural friction across a codebase and propose refactors toward deep modules as RFCs. Use when asked to audit architecture, find structural friction, or spot refactor opportunities. Don't use for one module's interface (/codebase-design) or a diff (/code-review).
---

# Architecture Audit

Audit a codebase for architectural friction and propose refactors toward **deep modules** (simple interface, large implementation). Deep modules are more testable, more AI-navigable, and let you test at the seam instead of inside.

Uses the deep-module vocabulary and principles — see [codebase-design](../codebase-design/SKILL.md) for the canonical glossary (module, interface, depth, seam, adapter, leverage, locality) and core principles (deletion test, interface-as-test-surface, one-adapter-is-hypothetical). Use those terms exactly in every suggestion. For audit-specific examples and anti-patterns (pass-through, temporal decomposition, classitis, signs a module is too shallow), see [references/deep-modules.md](references/deep-modules.md).

## Workflow

### 1. Explore

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
- **Dependency category**: see [codebase-design DEEPENING.md](../codebase-design/references/DEEPENING.md)
- **Test impact**: what existing tests would be replaced by tests at the new seam

Do NOT propose interfaces yet. Ask which candidate to explore.

### 3. Design the interface

For the chosen candidate, run the Design-It-Twice procedure in [codebase-design DESIGN-IT-TWICE.md](../codebase-design/references/DESIGN-IT-TWICE.md): frame the problem space, spawn 3+ sub-agents with radically different constraints, compare, recommend. Then ask which design to use — your recommendation first, marked (Recommended).

### 4. Write improvement PRD

Save a markdown file named `architecture-<cluster-name>.md` using the template in [references/improvement-template.md](references/improvement-template.md). If `.specs/specs/` exists, save there; otherwise, save in `specs/`.

Fill with concrete details: file paths, function names, migration steps. Share the file path with the user when done.

## Rules

- Old unit tests on shallow modules are waste once seam tests exist — note them for deletion
- Don't introduce a new seam unless something actually varies across it (one adapter = hypothetical, two = real)
- Candidate scope turns out much larger than expected → surface it and re-scope before designing
