# Report Templates

## If Issues Found

List each finding with actionable recommendations:

```
### Security Issues Found

**file.ts:42** - API key detected
- Pattern: `API_KEY = "abc123..."`
- Recommendation: Move to environment variable, add to .gitignore, rotate key

**config.json:15** - AWS credentials
- Pattern: `AKIA...`
- Recommendation: Use AWS credential chain, never commit, rotate immediately

### Recommendations

1. Move secrets to external files (.env, secrets.json)
2. Add sensitive patterns to .gitignore
3. Rotate all exposed credentials immediately
4. Consider using git-filter-branch to remove from history
```

## If Clean

```
**Repository Security Assessment**

No credentials or sensitive data found in tracked files or history. Repository is clean.
```
