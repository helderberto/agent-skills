---
name: architecture-audit
description: Explore a codebase to surface architectural friction and propose deep-module refactors as GitHub issue RFCs. Use when user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable. Don't use for small one-off refactors or single-file cleanups.
---

# Architecture Audit

A **deep module** has a simple interface hiding a large implementation. Deep modules are more testable, more AI-navigable, and let you test at the boundary instead of inside. See [references/deep-modules.md](references/deep-modules.md) for examples and anti-patterns.

## Workflow

### 1. Explore

Use the Agent tool with subagent_type=Explore to navigate the codebase organically. Note where you experience friction:

- Understanding one concept requires bouncing between many small files
- A module's interface is nearly as complex as its implementation
- Pure functions extracted just for testability, but real bugs hide in how they're called
- Tightly-coupled modules create integration risk at the seams between them
- Areas that are untested or hard to test

The friction you encounter IS the signal.

### 2. Present candidates

Show a numbered list. For each candidate:

- **Cluster**: which modules/concepts are involved
- **Why they're coupled**: shared types, call patterns, co-ownership of a concept
- **Dependency category**: see [references/dependency-categories.md](references/dependency-categories.md)
- **Test impact**: what existing tests would be replaced by boundary tests

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
4. Dependency strategy (see [references/dependency-categories.md](references/dependency-categories.md))
5. Trade-offs

Present designs sequentially, compare in prose, then give your own recommendation. Be opinionated — if elements from multiple designs combine well, propose a hybrid.

### 6. User picks an interface

Ask: "Which interface design should we use?" — list each design as an option with preview showing the interface signature. Add "Your recommendation" as first option (Recommended) with the hybrid/recommended design in preview. Use AskUserQuestion when available; otherwise present as a numbered list.

## Rules

- Never propose an interface before the user picks a candidate (Step 3)
- Old unit tests on shallow modules are waste once boundary tests exist — note them for deletion
- Classify every candidate's dependency type before designing interfaces
- Show the problem space framing (Step 4) before sub-agents finish — don't wait

## Error Handling

- If exploration reveals a candidate scope much larger than expected → surface this and ask user to re-scope before proceeding
