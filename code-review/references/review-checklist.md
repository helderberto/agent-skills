# Review Checklist

## Critical (must fix before merge)

### Bugs
- [ ] Null/undefined dereferences without guards
- [ ] Off-by-one errors in loops/slices
- [ ] Race conditions or missing async/await
- [ ] Incorrect error handling (swallowed errors, wrong status codes)
- [ ] Wrong conditional logic (= vs ==, && vs ||)

### Security
- [ ] User input used in SQL/shell/eval without sanitization
- [ ] Secrets or credentials hardcoded
- [ ] Missing auth/permission checks on new endpoints
- [ ] XSS: unescaped user content rendered as HTML
- [ ] Insecure direct object references (IDOR)

### Data integrity
- [ ] Missing transactions for multi-step DB writes
- [ ] No validation on user-supplied data at boundaries
- [ ] Unsafe type assertions (`as`, `!`)

## Suggestions (worth considering)

### Performance
- [ ] N+1 queries (loop with DB call inside)
- [ ] Missing indexes for new query patterns
- [ ] Expensive computation in hot path (consider memoization)
- [ ] Large payloads sent to client unnecessarily

### Maintainability
- [ ] Function does more than one thing
- [ ] Magic numbers/strings without named constants
- [ ] Duplicated logic that could be extracted
- [ ] Test coverage missing for new branches

## Positives (call out good patterns)
- Clean separation of concerns
- Good error messages
- Defensive coding where appropriate
- Well-named variables and functions
