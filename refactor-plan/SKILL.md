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
- Present alternative approaches
- Define exactly what changes and what stays
- Check test coverage in affected areas

### 3. Break Down Work
Apply Martin Fowler's principle: "Make each refactoring step as small as possible, so that you can always see the program working."

- Create list of tiny commits
- Each commit leaves codebase working
- Sequential, not parallel changes

### 4. Create GitHub Issue
Use `gh issue create` with template (see [assets/template.md](assets/template.md))

Include:
- Problem statement
- Solution approach
- Detailed commit plan
- Implementation decisions
- Testing strategy
- Out of scope items

## Rules

- Each commit must keep codebase functional
- No implementation details in plan (focus on behavior)
- Verify test coverage before starting
- Get user approval on approach

## Error Handling

- If `gh issue create` fails → run `gh auth status` to verify authentication; offer to print the plan as markdown instead
- If test coverage is insufficient → note coverage gaps in the plan and add "add tests for X" as the first commit
- If codebase exploration reveals scope is larger than expected → revise the plan with user before proceeding

## See Also

- [tdd](../tdd/SKILL.md) — implement refactored code using test-driven development
