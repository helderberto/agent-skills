---
name: write-a-prd
description: Create a PRD through user interview, codebase exploration, and module design, saved locally to prds/. Use when user wants to write a PRD, create a product requirements document, or plan a new feature. Don't use for refactoring plans, bug reports, or small changes.
---

# PRD Writing

Skip steps already satisfied. If user provided a description via arguments, skip to Step 2.

## Workflow

### 1. Gather problem description
Ask the user for a detailed description of the problem and any solution ideas.

### 2. Explore codebase
Verify assertions and map current state: data models, services, API routes, frontend structure, and test patterns. Note what exists vs. what must be built.

### 3. Interview
Interview relentlessly. Lead with your recommended answer as the first option (Recommended); the user confirms by selecting it or corrects via another option. Group related questions when possible (up to 4). Use AskUserQuestion when available; otherwise present options as a numbered list. If a question can be answered by exploring code, explore instead of asking.

Walk these branches (skip any already resolved):

- **Scope & Surface** -- Where does this live? New page/view or integrated? Which user roles?
- **Data & Concepts** -- Precise definitions for each new concept. What data exists, what's missing?
- **Behavior & Interaction** -- How does the user interact? Sorting, filtering, search, time ranges?
- **Display & Output** -- Numbers, tables, charts, forms? Exportable? URL-driven state?
- **Access & Privacy** -- Who sees what? Role-based restrictions? Sensitive data concerns?
- **Boundaries** -- What is explicitly out of scope? Adjacent features to defer?
- **Integration** -- Schema changes? New or extended services? External dependencies?

### 4. Design modules
Sketch major modules to build or modify. Favor **deep modules** -- a simple interface (1-3 entry points) hiding a large implementation that rarely changes, over shallow modules where the interface is nearly as complex as the implementation.

Signals of shallow design: many small functions with 1:1 query mapping, callers compose multiple calls, adding a feature requires changing the interface.

Present modules to user. Confirm which need tests (multiSelect): list each module as an option with a description of what tests would cover. Use AskUserQuestion when available; otherwise present as a checklist for the user to confirm.

### 5. Write PRD
Save to `prds/<kebab-case-name>.md` (create `prds/` if missing).

~~~markdown
# Feature Name

## Problem Statement

The problem from the user's perspective. Focus on pain and impact.

## Solution

The solution from the user's perspective. Describe the experience, not the architecture.

## User Stories

Long numbered list. Cover happy path, edge cases, error states.

1. As a <actor>, I want <feature>, so that <benefit>

## Implementation Decisions

### New Modules
- Module name, purpose, and public interface (function signatures with param types)
- Why each module exists as a separate unit

### Architectural Decisions
- Key definitions (precise meaning of domain terms)
- Data flow from storage to display
- State management approach

### Schema Changes
- New tables/columns needed, or "None required"

### API Contracts
- New routes, request/response shapes

### Navigation
- Where the feature is accessed, new routes added

Do NOT include file paths or code snippets -- they go stale.

## Testing Decisions

- What makes a good test (behavior, not implementation)
- Which modules need tests
- Key test cases (empty state, boundaries, isolation)
- Prior art: similar test patterns in the codebase

## Out of Scope

Explicit list. Be specific -- vague exclusions invite scope creep.
~~~

## Error Handling

- `prds/` missing -- create it
- Scope larger than expected -- surface and re-scope with user before continuing
