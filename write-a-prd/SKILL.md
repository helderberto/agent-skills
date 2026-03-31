---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, saved locally to prds/. Use when user wants to write a PRD, create a product requirements document, or plan a new feature. Don't use for refactoring plans, bug reports, or small changes.
---

# PRD Writing

You may skip steps if you don't consider them necessary. If user provided a description via arguments, skip straight to Step 2.

## Workflow

### 1. Gather problem description
Ask the user for a long, detailed description of the problem they want to solve and any potential ideas for solutions.

### 2. Explore codebase
Verify the user's assertions and understand the current state of the codebase: relevant data models, existing services, API routes, and frontend structure. Note what already exists vs. what needs to be built.

### 3. Interview
Interview the user relentlessly about every aspect of this plan until you reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. One question at a time; lead with your recommended answer and let the user confirm or correct.

If a question can be answered by exploring the codebase, explore instead of asking. If the user gives terse answers, offer concrete options (A/B/C).

### 4. Design modules
Sketch the major modules to build or modify. Actively look for opportunities to extract **deep modules** — a simple, testable interface that encapsulates a lot of functionality and rarely changes (as opposed to a shallow module that leaks implementation details).

Present the modules to the user. Confirm which modules they want tests written for.

### 5. Write PRD
Save to `prds/<kebab-case-name>.md` in the project root (create `prds/` if it doesn't exist). Use this template:

```markdown
## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A long, numbered list of user stories covering all aspects of the feature:

1. As a <actor>, I want <feature>, so that <benefit>

## Implementation Decisions

- Modules to build or modify and their interfaces
- Architectural decisions
- Schema changes
- API contracts
- Technical clarifications

Do NOT include specific file paths or code snippets — they go stale fast.

## Testing Decisions

- What makes a good test for this feature (test external behavior, not implementation details)
- Which modules will be tested
- Prior art: similar test patterns already in the codebase

## Out of Scope

What is explicitly not included in this PRD.

## Further Notes

Any additional context or open questions.
```

## Error Handling

- `prds/` missing → create it before writing
- Codebase exploration reveals scope much larger than expected → surface this and re-scope with user before continuing
