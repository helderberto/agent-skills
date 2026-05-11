---
name: harden
description: Harden code proactively against vulnerabilities at the boundary where untrusted input enters the system. Use when implementing auth, handling user input, storing or transmitting sensitive data, integrating external APIs, adding file uploads, or any code that crosses a trust boundary. Don't use for reactive secret scanning (use `safe-repo`) or dependency CVE checks (use `deps-audit`).
---

# Harden

Security as a constraint on every line that touches user data, auth, or external systems. This skill is **proactive**: applied during implementation, not after. For reactive scans, use `safe-repo` (sensitive data) or `deps-audit` (CVEs).

## When to Use

- Building anything that accepts user input
- Implementing authentication or authorization
- Storing or transmitting sensitive data
- Integrating with external APIs or webhooks
- Adding file uploads, payments, or PII handling

## Three-Tier Boundary System

### Always do (no exceptions)

- Validate every external input at the system boundary (route handler, API entry)
- Parameterize all database queries (never concatenate user input into SQL)
- Encode output to prevent XSS — use framework auto-escaping, don't bypass it
- HTTPS for all external communication
- Hash passwords with bcrypt/scrypt/argon2 (salt rounds ≥ 12); never plaintext
- Set security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options
- Session cookies: `httpOnly`, `secure`, `sameSite`
- Use environment variables for secrets; reference, never inline

### Ask first (human approval required)

- New authentication flow or auth logic changes
- Storing new categories of sensitive data (PII, payment)
- New external service integrations
- CORS configuration changes
- File upload handlers
- Rate-limit / throttling changes
- Granting elevated permissions or roles

### Never do

- Commit secrets to version control
- Log sensitive data (passwords, tokens, full PAN)
- Trust client-side validation as a security boundary
- Disable security headers for convenience
- Use `eval()` or `innerHTML` with user-provided data
- Store sessions in client-accessible storage (e.g., localStorage for auth tokens)
- Expose stack traces or internal errors to users

## OWASP Top 10 — Quick Reference

| Risk | Mitigation |
|------|------------|
| Injection (SQL/NoSQL/OS) | Parameterized queries; ORM with bound params; never concat user input |
| Broken authentication | bcrypt/argon2 hashing; httpOnly+secure+sameSite cookies; rate-limit auth endpoints |
| XSS | Framework auto-escape; sanitize with DOMPurify if HTML is unavoidable |
| Broken access control | Check authorization on EVERY endpoint; verify ownership, not just authentication |
| Misconfiguration | helmet for headers; CORS restricted to known origins via env var |
| Sensitive data exposure | Strip sensitive fields before API response; env vars for secrets |
| Insufficient logging | Log auth failures, access denials, input rejections |
| SSRF | Allowlist outbound destinations; never fetch user-provided URLs without validation |

## Input Validation at Boundaries

Always validate at the **system boundary** (route handler, message consumer), not in business logic:

- Schema validator (Zod, Joi, Yup, pydantic) defines the contract
- Reject with 422 + structured error before any business logic touches the data
- Trust internal code; validate only at the edges

## File Upload Safety

- Allowlist MIME types; deny unknown
- Enforce max size before processing
- Check magic bytes if file type is security-critical (don't trust extension or `mimetype`)
- Store outside webroot or behind authenticated access

## Triaging `npm audit` / CVE findings

```
Critical or High severity?
├── Vulnerable code reachable in your app?
│   ├── YES → Fix immediately
│   └── NO (dev-only, unused path) → Fix soon, not a blocker
└── Fix available?
    ├── YES → Update to patched version
    └── NO → Workaround / replace dep / allowlist with review date
```

Defer with documented reason and review date. Never silent allowlist.

## Secrets Management

```
.env.example   → committed (template, placeholder values)
.env           → NOT committed (real secrets)
.env.local     → NOT committed (local overrides)
*.pem, *.key   → NOT committed
```

Pre-commit check: `git diff --cached | grep -iE "password|secret|api_key|token"`. Better: `safe-repo --diff` as part of `ship`.

## Rules

- Validate at boundaries; trust internal code
- Use framework defaults (helmet, parameterized ORMs, framework escaping)
- Read secrets from env vars; never inline
- Authorization checked on every protected endpoint
- Strip sensitive fields from API responses by default
- Never trust client-side validation as a security boundary

## Red Flags

- User input flowing directly into SQL string, shell command, or HTML render
- Secrets in source code or commit history
- API endpoint without authentication or authorization check
- CORS wildcard (`*`) or no CORS config
- No rate limit on auth endpoints
- Stack traces returned to users
- Dependencies with known critical CVEs and no plan

## Verification

After implementing security-relevant code, confirm:

- [ ] `deps-audit` shows no critical or high CVEs (or each is documented with review date)
- [ ] `safe-repo --diff` clean
- [ ] All user input validated at system boundaries
- [ ] Authorization checked on every protected endpoint (ownership, not just auth)
- [ ] Security headers present in response (check via DevTools or `curl -I`)
- [ ] Error responses don't expose internal details
- [ ] Rate limit active on auth endpoints

## Common Rationalizations

| Rationalization | Reality |
|-----------------|---------|
| "Internal tool, security doesn't matter" | Internal tools get compromised; attackers target the weakest link |
| "We'll add security later" | Retrofitting is 10x harder than building it in |
| "No one would exploit this" | Automated scanners will; security-by-obscurity is not security |
| "Framework handles security" | Frameworks provide tools, not guarantees |
| "It's a prototype" | Prototypes become production; habits compound |
