---
name: harden
effort: xhigh
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

See [OWASP Top 10 quick reference](references/owasp.md).

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

For dependency CVEs see `deps-audit`; for secrets and sensitive data see `safe-repo`.

## Rules

- Validate at boundaries; trust internal code
- Use framework defaults (helmet, parameterized ORMs, framework escaping)
- Read secrets from env vars; never inline
- Authorization checked on every protected endpoint
- Strip sensitive fields from API responses by default
- Never trust client-side validation as a security boundary

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
