# Refactor Plan Template

Use this template when creating GitHub issues for refactoring plans.

```markdown
## Problem Statement

The problem that the developer is facing, from the developer's perspective.

## Solution

The solution to the problem, from the developer's perspective.

## Commits

A LONG, detailed implementation plan. Write the plan in plain English, breaking down the implementation into the tiniest commits possible. Each commit should leave the codebase in a working state.

Example:
1. Add new interface type for UserProfile
2. Update UserService to accept new interface (keep old code path)
3. Add tests for new code path
4. Update component to use new interface
5. Remove old code path
6. Update documentation

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this refactor.

## Further Notes (optional)

Any further notes about the refactor.
```

## Example Issue Creation

```bash
gh issue create --title "Refactor: Extract authentication logic" --body "$(cat <<'EOF'
## Problem Statement
Authentication logic is scattered across multiple components, making it hard to maintain and test.

## Solution
Extract authentication into dedicated AuthService with clear interface.

## Commits
1. Create AuthService interface
2. Move login logic to AuthService
3. Add tests for AuthService
4. Update LoginComponent to use AuthService
5. Move logout logic to AuthService
6. Update HeaderComponent to use AuthService
7. Remove old auth utilities
8. Update documentation

## Implementation Decisions
- AuthService will use singleton pattern
- Keep token management in separate TokenService
- Use existing HTTP client for API calls

## Testing Decisions
- Mock HTTP client in tests
- Test public interface only
- Follow existing test patterns in src/services/

## Out of Scope
- OAuth integration (future work)
- Password reset flow (separate issue)
EOF
)"
```
