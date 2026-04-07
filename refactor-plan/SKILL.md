---
name: refactor-plan
description: Create structured refactoring plans. Use when user wants to plan a refactor, needs a refactoring strategy, or mentions breaking down large changes into small commits. Don't use for implementing code changes directly, small one-line fixes, or renaming a single variable.
---

# Refactor Planning

## Process

### 1. Understand Problem
- Get detailed description from user
- Ask about potential solutions they've considered
- Explore codebase to verify current state

### 2. Define Scope
- Interview user about implementation details
- Present alternative approaches via AskUserQuestion — each approach as an option with trade-offs in description; use preview to show code sketches when applicable
- Define exactly what changes and what stays
- Check test coverage in affected areas

### 3. Break Down Work
Apply Martin Fowler's principle: "Make each refactoring step as small as possible, so that you can always see the program working."

- Create list of tiny commits
- Each commit leaves codebase working
- Sequential, not parallel changes

### 4. Create GitHub Issue

```bash
gh issue create --title "Refactor: <title>" --body "$(cat <<'EOF'
## Problem Statement

The problem from the developer's perspective.

## Solution

The approach from the developer's perspective.

## Commits

Detailed plan broken into the tiniest commits possible. Each leaves codebase working.

1. Add new interface type
2. Update service to accept new interface (keep old code path)
3. Add tests for new code path
4. Update consumers to use new interface
5. Remove old code path

## Implementation Decisions

- Modules to build/modify and their interfaces
- Architectural decisions
- Schema changes
- API contracts

Do NOT include file paths or code snippets -- they go stale.

## Testing Decisions

- What makes a good test (behavior, not implementation)
- Which modules need tests
- Prior art: similar test patterns in the codebase

## Out of Scope

What is explicitly not included.
EOF
)"
```

## Rules

- Each commit must keep codebase functional
- No implementation details in plan (focus on behavior)
- Verify test coverage before starting
- Get user approval on approach

## Error Handling

- `gh issue create` fails -- run `gh auth status` to verify auth; offer to print as markdown instead
- Test coverage insufficient -- note gaps and add "add tests for X" as first commit
- Scope larger than expected -- revise plan with user before proceeding

## See Also

- [tdd](../tdd/SKILL.md) -- implement refactored code using test-driven development
