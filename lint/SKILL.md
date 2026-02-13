
# Linting

## Standard Command

`npm run lint` - runs `tsc --noEmit && eslint`

## Workflow

1. Run `npm run lint`
2. For fixes: `npm run lint-fix`
3. Report file:line references

## Rules

- Use project's `package.json` scripts
- Never use `npx` directly
- Don't auto-fix unless requested
