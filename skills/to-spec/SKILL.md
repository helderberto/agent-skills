---
name: to-spec
effort: high
description: Turn the settled conversation into a spec (PRD), published through the repo's tracker: `.specs/specs/<slug>.md` by default.
disable-model-invocation: true
argument-hint: <idea>
---

# To Spec

Idea: $ARGUMENTS (if empty, ask for the problem and any solution ideas first).

Derive a kebab-case `<slug>` from the text before the first `—`/`–` (≤4 meaningful words, no command verbs or filler). Output: the spec, in the tracker.

**Tracker**: follow `.specs/issue-tracker.md`, else [the local default](../setup/issue-tracker-local.md), for where specs and tickets live and when a ticket is done.

## Workflow

### 1. Explore codebase

Map current state: data models, services, API routes, frontend, tests. Note exists vs. must build. Codebase first, then docs. Unverifiable claims → flag as uncertain, never fabricate.

### 2. Check the branches

Never interview here. Check each branch below against the conversation and the code: settled → synthesize it. Open branches → one confirm round at most, each question with your recommended answer. Still open after that → stop with `Next: /hb:grill <slug>`. A domain term that settles here → call the Skill tool with `domain-modeling` to write it into the glossary, so spec and glossary agree.

| Branch           | Key questions                           | Skip when                        |
| ---------------- | --------------------------------------- | -------------------------------- |
| Scope & Surface  | Where? New page or integrated? Roles?   | CLI/library, no new entry points |
| Data & Concepts  | Definitions, existing vs missing data   | Never skip                       |
| Behavior         | Interaction patterns, filtering, search | No user-facing behavior          |
| Display          | Numbers, tables, charts, exports        | No UI                            |
| Access & Privacy | Who sees what? Sensitive data?          | Single-user, no auth             |
| Boundaries       | Out of scope, deferred features         | Never skip                       |
| Integration      | Schema, services, external deps         | Self-contained change            |

**Gray areas** — ambiguities, contradictions, unstated assumptions — join that same round, each with a proposed resolution.

### 3. Design modules

Sketch modules. Favor **deep modules** — simple interface (1–3 entry points) hiding large implementation. Shallow signals: many 1:1 functions, callers compose multiple calls, feature changes require interface changes. Mark which modules need tests.

### 4. Write spec

Draft it. Omit empty sections. No file paths or code snippets. A related ticket (a key or `#42` in the conversation, the argument, or the branch name) → record it in frontmatter; no ticket → no frontmatter.

```
---
ticket: <key>
---
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

### 5. Publish

Publish the spec to the tracker. GitHub or Jira → name the target and confirm once. The argument names an existing spec → update it instead.

Next: `/hb:to-tickets <spec ref>`
