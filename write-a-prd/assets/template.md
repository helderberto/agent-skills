# PRD Template

Use this template when writing PRDs. Save to `specs/<kebab-case-name>.md` in the project root.

```markdown
## Problem Statement

The problem the user is facing, from the user's perspective. Focus on pain and impact, not implementation.

## Solution

The solution from the user's perspective. Describe the experience, not the architecture.

## User Stories

A LONG, numbered list. Each story follows: "As an <actor>, I want <feature>, so that <benefit>".

Example:
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending

Cover all aspects: happy path, edge cases, filtering, navigation, error states.

## Implementation Decisions

Organized by concern:

### New Modules
- Module name, purpose, and public interface (function signatures with parameter types)
- Why each module exists as a separate unit

### Architectural Decisions
- Key definitions (e.g., what "completion" means precisely)
- How data flows from storage to display
- Time filtering strategy
- State management approach (URL params, local state, etc.)

### Schema Changes
- New tables or columns needed (or "None required" if existing schema suffices)
- Note storage formats (e.g., prices in cents)

### API Contracts
- New routes or loader changes
- Request/response shapes

### Navigation
- Where the feature is accessed from
- New routes or links added

Do NOT include specific file paths or code snippets — they go stale fast.

## Testing Decisions

- What makes a good test for this feature (test behavior, not implementation)
- Which modules need tests
- Key test cases to cover (empty state, boundaries, isolation, ordering)
- Prior art: existing test patterns to follow in the codebase

## Out of Scope

Explicit list of what this PRD does NOT cover. Be specific — vague exclusions invite scope creep.

## Further Notes

Data format caveats, privacy considerations, performance concerns, or anything that could surprise an implementer.
```

## Filename Convention

Use kebab-case derived from the feature name: `specs/instructor-analytics-dashboard.md`

Add a top-level heading matching the feature title:

```markdown
# Instructor Analytics Dashboard

## Problem Statement
...
```
