---
name: i18n
description: Audit internationalization coverage and find hardcoded strings. Use when user asks to "check i18n", "/i18n", "find hardcoded strings", "check translations", or wants to verify translation coverage.
allowed-tools: Read Glob Grep
---

# i18n Audit

## Detection

Read `package.json` for i18n library:
- `react-i18next` / `i18next`
- `next-intl`
- `vue-i18n`
- `react-intl` (FormatJS)

Read locale files to understand key structure (e.g. `src/locales/en.json`).

## Workflow

1. Detect i18n library and locale file locations
2. Search JSX/TSX/Vue files for hardcoded user-facing strings (see [patterns.md](references/patterns.md)):
   - String literals in JSX: `<p>Hello world</p>`
   - String props: `placeholder="Search..."`, `label="Submit"`
   - `aria-label="Close menu"`
3. Compare locale files — find missing keys between locales:
   ```bash
   # keys in en.json but missing in pt.json
   ```
4. Report findings

## Output format

**Hardcoded strings** (`file:line`):
```
src/components/Header.tsx:12  "Welcome back"  → suggest key: header.welcomeBack
src/components/Form.tsx:34    placeholder="Search..."  → suggest key: form.searchPlaceholder
```

**Missing translations** (key present in base locale but absent in others):
```
Key: dashboard.emptyState  missing in: pt-BR, es
Key: errors.networkTimeout  missing in: pt-BR
```

## Rules

- Only flag user-visible strings (skip internal IDs, CSS classes, URLs, enum values)
- Suggest translation key names in camelCase matching project convention
- Never auto-modify locale files — report only
