---
name: spec
effort: high
description: Create a spec (PRD) through user interview, codebase exploration, and module design. Use when starting a feature with unclear requirements, or asked to spec or define what to build, "write a spec", "write a PRD". Don't use when requirements are crisp and a plan exists (/plan, /build).
argument-hint: <idea>
---

# Spec

Idea: $ARGUMENTS (if empty, ask for the problem and any solution ideas first).

Derive a kebab-case `<slug>` from the text before the first `—`/`–` (≤4 meaningful words, no command verbs or filler). Output: `.specs/specs/<slug>.md`. If it exists, update it in place (Recommended) or pick a new name.

## Workflow

### 1. Explore codebase

Map current state: data models, services, API routes, frontend, tests. Note exists vs. must build. Codebase first, then docs. Unverifiable claims → flag as uncertain, never fabricate.

### 2. Interview

Call the Skill tool with `grill-me`, seeded with the branches below as the design tree. Skip branches the conversation already settled: synthesize those, don't re-ask. Explore code instead of asking when possible. When a domain term settles mid-grill, call the Skill tool with `domain-modeling` to write it into the glossary, so spec and glossary agree.

| Branch           | Key questions                           | Skip when                        |
| ---------------- | --------------------------------------- | -------------------------------- |
| Scope & Surface  | Where? New page or integrated? Roles?   | CLI/library, no new entry points |
| Data & Concepts  | Definitions, existing vs missing data   | Never skip                       |
| Behavior         | Interaction patterns, filtering, search | No user-facing behavior          |
| Display          | Numbers, tables, charts, exports        | No UI                            |
| Access & Privacy | Who sees what? Sensitive data?          | Single-user, no auth             |
| Boundaries       | Out of scope, deferred features         | Never skip                       |
| Integration      | Schema, services, external deps         | Self-contained change            |

Then surface **gray areas** — ambiguities, contradictions, unstated assumptions — each with proposed resolutions. Resolve all before continuing.

### 3. Design modules

Sketch modules. Favor **deep modules** — simple interface (1–3 entry points) hiding large implementation. Shallow signals: many 1:1 functions, callers compose multiple calls, feature changes require interface changes. Confirm which modules need tests.

### 4. Write spec

Save to `.specs/specs/<slug>.md`. Omit empty sections. No file paths or code snippets.

```
# Feature Name
## Problem Statement
## Current State (skip if greenfield)
## Solution (user experience, not architecture)
## User Stories (numbered, cover happy + edge + error)
## Implementation Decisions
### New Modules (name, purpose, interface signatures)
### Architectural Decisions (definitions, data flow, state)
### Schema Changes
### API Contracts
### Navigation
## Testing Decisions (behavior tests, key cases, prior art)
## Out of Scope (be specific)
```

Next: `/plan <slug>` (Recommended) or done for now.
