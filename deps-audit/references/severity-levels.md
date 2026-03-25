# Vulnerability Severity Levels

| Level | CVSS Score | Action |
|---|---|---|
| **Critical** | 9.0–10.0 | Fix immediately, block merge |
| **High** | 7.0–8.9 | Fix before next release |
| **Moderate** | 4.0–6.9 | Fix in current sprint |
| **Low** | 0.1–3.9 | Fix when convenient |
| **Info** | 0.0 | No action required |

## Report Format

For each critical/high vulnerability:
```
Package: <name>@<version>
CVE: CVE-YYYY-XXXXX
Severity: Critical
Description: <one line>
Fix: npm audit fix --force  (or specific: npm install <pkg>@<safe-version>)
```

## Fix Commands

```bash
# Auto-fix (safe upgrades only)
npm audit fix

# Force fix (may include breaking changes — review diff)
npm audit fix --force

# Pin specific package to safe version
npm install <package>@<safe-version>
```
