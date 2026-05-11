# Credential Patterns

Search patterns for detecting sensitive data in repositories.

## Credential Searches

Run in parallel against `git ls-files` output:

### API Keys
```bash
git ls-files | xargs grep -i -E "(api[_-]?key|api[_-]?secret|access[_-]?token)" 2>/dev/null
```

### Passwords
```bash
git ls-files | xargs grep -i -E "(password|passwd|pwd)['\"]?\s*[:=]" 2>/dev/null
```

### Private Keys
```bash
git ls-files | grep -E "\.(pem|key)$|_rsa"
```

### Tokens
```bash
git ls-files | xargs grep -i -E "(bearer|token|secret)['\"]?\s*[:=]\s*['\"][^'\"]{20,}" 2>/dev/null
```

### AWS Credentials
```bash
git ls-files | xargs grep -E "AKIA[0-9A-Z]{16}" 2>/dev/null
```

## Sensitive File Patterns

### Environment Files
```bash
git ls-files | grep "\.env" | grep -v "\.env\.example"
```

### Secret Files
```bash
git ls-files | grep -i -E "(secret|credential)"
```

## Git History Check

```bash
git log --all --full-history --oneline -- "*.env" "*.pem" "*.key" "*secret*" "*credential*"
```

## False Positives to Filter

- Minified JavaScript files
- node_modules directory
- Test fixtures and mock data
- Documentation examples
