---
name: component
description: Scaffold a new UI component following project conventions. Use when user asks to "create a component", "/component", "scaffold a component", or wants to add a new component with tests and types.
argument-hint: "<ComponentName> [--story] [--no-test]"
allowed-tools: Read Glob Grep Write Bash(git:*)
---

# Scaffold Component

Component name: $ARGUMENTS

## Detection

Run in parallel:
- Read `package.json` — detect framework (React/Vue/Svelte), TypeScript, test runner, Storybook
- Glob `src/components/**` or `src/features/**` — detect project structure pattern
- Read 1-2 existing components — match naming, export style, import conventions

## Structure patterns

See [project-structures.md](references/project-structures.md) for conventions by pattern.

Detect from existing codebase:
- **Atomic**: `src/components/atoms/`, `molecules/`, `organisms/`
- **Feature folders**: `src/features/<feature>/components/`
- **Flat**: `src/components/<ComponentName>/`

## Files to generate

1. **Component** — `<ComponentName>.tsx` (or `.vue`, `.svelte`)
   - Match prop typing style from existing components
   - Named export (not default unless project uses default)
2. **Types** — inline in component file if project does; separate `types.ts` if project does
3. **Test** — `<ComponentName>.test.tsx` (skip if `--no-test`)
   - Test rendering, key interactions, and edge cases
   - Match test style from existing test files
4. **Story** — `<ComponentName>.stories.tsx` (only if Storybook detected or `--story` passed)
   - CSF3 format for Storybook v7+

## Rules

- Read existing components before generating — match conventions exactly
- Never invent prop names or patterns not present in the project
- Use the same import aliases found in the project (`@/`, `~/`, etc.)
- If framework or structure is unclear, ask before generating
