---
name: to-spec
effort: high
description: Turn the settled conversation into a spec (PRD): `.specs/specs/<slug>.md` by default, or one issue in the tracker `/hb:setup` configured.
disable-model-invocation: true
argument-hint: <idea>
---

# To Spec

Idea: $ARGUMENTS (if empty, ask for the problem and any solution ideas first).

Derive a kebab-case `<slug>` from the text before the first `—`/`–` (≤4 meaningful words, no command verbs or filler). **Local mode** (the default): no `.specs/issue-tracker.md`, or the argument says "local only". **Tracker mode**: `.specs/issue-tracker.md` exists; follow its commands.

Output: local mode → `.specs/specs/<slug>.md`; if it exists, update it in place (Recommended) or pick a new name. Tracker mode → one issue, no local file.

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

Local mode → save to `.specs/specs/<slug>.md`. Tracker mode → draft in a temp file outside the repo. Omit empty sections. No file paths or code snippets. A related ticket (a key or `#42` in the conversation, the argument, or the branch name) → record it in frontmatter; no ticket → no frontmatter.

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

Tracker mode only. Name the target and confirm once. Create one issue: title = feature name, body = the spec. The argument names an existing spec issue → update its body instead. Delete the temp file: the issue is the only copy.

Next: `/hb:to-tickets <slug>` (local) or `/hb:to-tickets <ref>` (tracker)
