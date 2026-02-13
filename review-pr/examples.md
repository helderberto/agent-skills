# PR Review Examples

## Example 1: Logic Issue

**Finding:**
```
src/auth.ts:45 - Missing null check before accessing user.email

Current:
if (user.role === 'admin') {
  sendEmail(user.email)
}

Issue: user could be undefined if session expired

Suggested fix:
if (user?.role === 'admin' && user.email) {
  sendEmail(user.email)
}
```

## Example 2: Performance Concern

**Finding:**
```
src/components/UserList.tsx:23 - Expensive operation in render

Issue: Array.filter runs on every render without memoization

Suggested fix:
const filteredUsers = useMemo(
  () => users.filter(u => u.active),
  [users]
)
```

## Example 3: Missing Tests

**Finding:**
```
src/utils/validation.ts - New validation function lacks tests

Added: validatePhoneNumber()
Missing: Unit tests for edge cases

Suggest adding tests for:
- Valid formats: (555) 123-4567, 555-123-4567, 5551234567
- Invalid formats: abc, 123, empty string
- International formats
```

## Example 4: Security Issue

**Finding:**
```
src/api/client.ts:67 - Potential XSS vulnerability

Issue: User input directly interpolated into HTML
const html = `<div>${user.name}</div>`

Suggested fix: Use proper escaping or React JSX
<div>{user.name}</div>
```

## Example 5: Positive Feedback

**Finding:**
```
src/hooks/useDebounce.ts - Well implemented

✓ Clean implementation with proper cleanup
✓ TypeScript types are correct
✓ Tests cover edge cases
✓ Documentation is clear

Nice work on the cancellation logic!
```

## Review Checklist

- [ ] Logic errors or bugs
- [ ] Performance issues
- [ ] Missing error handling
- [ ] Security vulnerabilities
- [ ] Missing tests
- [ ] Code readability
- [ ] Follows project patterns
- [ ] Breaking changes documented
