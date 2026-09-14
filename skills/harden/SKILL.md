---
name: harden
effort: xhigh
description: Harden code proactively against vulnerabilities where untrusted input enters the system. Use when implementing auth, handling user input, storing or transmitting sensitive data, integrating external APIs, adding file uploads, or any code crossing a trust boundary. Don't use for reactive secret scanning (/safe-repo) or dependency CVEs (/deps-audit).
---

# Harden

Security as a constraint on every line that touches user data, auth, or external systems. **Proactive**: applied during implementation, not after. Reactive scans belong to `safe-repo` (sensitive data) and `deps-audit` (CVEs).

## Ask first — human approval required

- New authentication flow or auth logic changes
- Storing new categories of sensitive data (PII, payment)
- New external service integrations
- CORS configuration changes
- File upload handlers
- Rate-limit / throttling changes
- Granting elevated permissions or roles

## Validate at the boundary

Validate at the **system boundary** (route handler, message consumer), not in business logic: a schema validator (Zod, Joi, pydantic, …) defines the contract; reject with 422 + structured error before business logic touches the data. Trust internal code; validate only at the edges.

## Defaults that are easy to forget

- Authorization per resource (ownership), not just authentication
- Session cookies `httpOnly` + `secure` + `sameSite`; auth tokens never in `localStorage`
- Strip sensitive fields from API responses by default
- Security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options)
- Rate limit on auth endpoints
- Logs and error responses free of secrets, tokens, PII, stack traces
- File uploads: allowlist MIME types, enforce max size before processing, check magic bytes when the type matters, store outside the webroot
- Outbound requests: allowlist destinations; never fetch a user-provided URL unvalidated (SSRF)
- CORS: explicit origin allowlist from config; no wildcard on authenticated endpoints
- External integrations: verify webhook signatures, time out every external call, validate third-party response shapes before use; never deserialize untrusted input with unsafe loaders
- Log security events (auth failures, access denials, input rejections) — without the payloads
- Raw HTML from users only through a sanitizer (DOMPurify or equivalent)

## Verification

After security-relevant code: `deps-audit` shows no critical/high CVEs (or each documented with review date); `safe-repo --diff` clean; headers present (`curl -I`); authz checked on every protected endpoint.
