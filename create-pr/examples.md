# Pull Request Examples

## Example 1: Feature PR

**Title:** Add user search functionality

**Body:**
```markdown
## Summary
- Adds search bar to user list page
- Implements debounced search with 300ms delay
- Filters by name, email, or role

## Test Plan
- [ ] Search filters users by name
- [ ] Search filters users by email
- [ ] Search filters users by role
- [ ] Empty search shows all users
- [ ] Loading state displays during search
```

## Example 2: Bug Fix PR

**Title:** Fix login redirect loop

**Body:**
```markdown
## Summary
Fixes infinite redirect when session expires during navigation.

Root cause: auth middleware wasn't clearing stale session before redirect.

## Test Plan
- [ ] Login successfully redirects to dashboard
- [ ] Expired session redirects to login once
- [ ] Manual logout works correctly
```

## Example 3: Refactor PR

**Title:** Extract validation utilities

**Body:**
```markdown
## Summary
- Consolidates duplicate validation logic across forms
- Creates `src/utils/validation.ts` with reusable validators
- Updates 5 form components to use new utilities

No behavior changes.

## Test Plan
- [ ] All existing validation tests pass
- [ ] Form validation still works as expected
```

## Example 4: Using PR Template

**If `.github/pull_request_template.md` exists:**
```markdown
## What does this PR do?
Adds user search with debounced input

## Type of change
- [x] New feature
- [ ] Bug fix
- [ ] Breaking change

## How has this been tested?
- Unit tests for search hook
- Integration tests for search component
- Manual testing in dev environment

## Checklist
- [x] Tests added/updated
- [x] Documentation updated
- [x] No breaking changes
```
