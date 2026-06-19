---
name: architecture-audit
description: Explore a codebase to surface architectural friction and propose refactors toward deep modules (simple interface, large implementation) as GitHub issue RFCs.
disable-model-invocation: true
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

Do NOT propose interfaces yet. Ask: "Which candidate would you like to explore?" — list each candidate as an option with its cluster name as label and coupling summary as description. Use AskUserQuestion when available; otherwise present as a numbered list.

### 3. User picks a candidate

### 4. Frame the problem space

Write a user-facing explanation of the chosen candidate:

- Constraints any new interface must satisfy
- Dependencies it would need to rely on
- A rough illustrative code sketch to ground the constraints (not a proposal)

Show this to the user, then immediately proceed to Step 5. User reads while sub-agents work.

### 5. Design multiple interfaces

Spawn 3+ sub-agents in parallel using the Agent tool. Each produces a **radically different** interface. Give each a separate technical brief (file paths, coupling details, dependency category). Assign distinct constraints:

- Agent 1: "Minimize — aim for 1–3 entry points max"
- Agent 2: "Maximize flexibility — support many use cases and extension"
- Agent 3: "Optimize for the most common caller — make the default case trivial"
- Agent 4 (if applicable): "Design around ports & adapters for cross-boundary dependencies"

Each sub-agent outputs:
1. Interface signature
2. Usage example
3. What complexity it hides internally
4. Dependency strategy (see [codebase-design DEEPENING.md](../codebase-design/references/DEEPENING.md))
5. Trade-offs

Present designs sequentially, compare in prose, then give your own recommendation. Be opinionated — if elements from multiple designs combine well, propose a hybrid.

### 6. User picks an interface

Ask: "Which interface design should we use?" — list each design as an option with preview showing the interface signature. Add "Your recommendation" as first option (Recommended) with the hybrid/recommended design in preview. Use AskUserQuestion when available; otherwise present as a numbered list.

### 7. Write improvement PRD

Save a markdown file named `architecture-<cluster-name>.md` using the template in [references/improvement-template.md](references/improvement-template.md). If `.specs/prds/` exists, save there; otherwise, save in `prds/`.

Fill with concrete details: file paths, function names, migration steps. Share the file path with the user when done.

## Rules

- Old unit tests on shallow modules are waste once seam tests exist — note them for deletion
- Don't introduce a new seam unless something actually varies across it (one adapter = hypothetical, two = real)

## Error Handling

- If exploration reveals a candidate scope much larger than expected → surface this and ask user to re-scope before proceeding
