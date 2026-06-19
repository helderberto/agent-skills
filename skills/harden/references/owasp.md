# OWASP Top 10 — Quick Reference

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
