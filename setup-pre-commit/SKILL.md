---
name: setup-pre-commit
description: "Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests. Use when user asks to \"add pre-commit hooks\", \"setup husky\", \"setup pre-commit\", \"configure lint-staged\", or wants commit-time formatting/typechecking/testing. Don't use for running linters manually or writing tests."
---

# Setup Pre-Commit Hooks

## Pre-loaded context

- package.json: !`cat package.json 2>/dev/null`

Before proceeding, use the Glob tool to detect:
- Lock file: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`
- Prettier config: `.prettierrc`, `.prettierrc.*`, `prettier.config.*`

## What This Sets Up

- **Husky** pre-commit hook
- **lint-staged** running Prettier on all staged files
- **Prettier** config (if missing)
- **typecheck** and **test** scripts in the pre-commit hook (if they exist)

## Workflow

1. **Detect package manager** from lock file: `package-lock.json` (npm), `pnpm-lock.yaml` (pnpm), `yarn.lock` (yarn), `bun.lockb` (bun). Default to npm if unclear.

2. **Install devDependencies**:
   ```
   husky lint-staged prettier
   ```

3. **Initialize Husky**:
   ```bash
   npx husky init
   ```
   This creates `.husky/` dir and adds `prepare: "husky"` to package.json.

4. **Create `.husky/pre-commit`** (no shebang needed for Husky v9+):
   ```
   npx lint-staged
   <pm> run typecheck
   <pm> run test
   ```
   Replace `<pm>` with detected package manager. If repo has no `typecheck` script in package.json, omit that line and tell the user. Same for `test`.

5. **Create `.lintstagedrc`**:
   ```json
   {
     "*": "prettier --ignore-unknown --write"
   }
   ```

6. **Create `.prettierrc`** (only if no Prettier config exists):
   ```json
   {
     "useTabs": false,
     "tabWidth": 2,
     "singleQuote": true,
     "trailingComma": "all"
   }
   ```

7. **Verify**:
   - `.husky/pre-commit` exists and is executable
   - `.lintstagedrc` exists
   - `prepare` script in package.json is `"husky"`
   - Prettier config exists
   - Run `npx lint-staged` to confirm it works

8. **Commit** all changed/created files: `Add pre-commit hooks (husky + lint-staged + prettier)`
   This runs through the new pre-commit hooks -- a good smoke test.

## Rules

- Never overwrite existing Prettier config
- Never overwrite existing `.husky/pre-commit` without asking user first
- Always use detected package manager consistently
- Husky v9+ doesn't need shebangs in hook files
- `prettier --ignore-unknown` skips files Prettier can't parse (images, etc.)
- Pre-commit runs lint-staged first (fast, staged-only), then full typecheck and tests

## Error Handling

- No `package.json` found -- report and stop
- Existing `.husky/pre-commit` -- ask user before overwriting
- `husky init` fails -- check node_modules exists, suggest running install first
- `npx lint-staged` verification fails -- check Prettier is installed, check `.lintstagedrc` syntax
- No `typecheck` or `test` scripts -- omit from hook, tell user which were skipped

## See Also

- [validate-code](../validate-code/SKILL.md) -- run lint/typecheck/tests manually
- [commit](../commit/SKILL.md) -- create git commits following repo style
