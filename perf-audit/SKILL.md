---
name: perf-audit
description: Audit frontend bundle size and performance. Use when user asks to "audit performance", "/perf-audit", "analyze bundle", "check bundle size", or wants to find performance bottlenecks.
compatibility: Requires a production build. Supports Vite, webpack, Next.js, and Rollup.
allowed-tools: Read Glob Grep Bash(npx:*) Bash(bunx:*) Bash(ls:*)
---

# Performance Audit

## Workflow

1. Detect build tool from `package.json` (vite, webpack, next, rollup)
2. Run production build if no recent build exists:
   - Vite: `npm run build`
   - Next.js: `npm run build` (reads `.next/analyze/` if `ANALYZE=true`)
3. Analyze bundle output (see [budget-thresholds.md](references/budget-thresholds.md)):

   **Vite:**
   ```bash
   npx vite-bundle-visualizer
   ```

   **webpack/Next.js:**
   ```bash
   npx webpack-bundle-analyzer <stats-file>
   ```

4. Check `package.json` dependencies for known heavy packages:
   - `moment` → suggest `date-fns` or `dayjs`
   - `lodash` → suggest tree-shakeable imports or native alternatives
   - `@mui/material` (full import) → suggest named imports
5. Report findings with size impact

## Output format

- **Bundle summary**: total size / gzipped size vs budget
- **Large chunks**: name + size + % of total
- **Heavy deps**: package + size + lighter alternative
- **Quick wins**: sorted by estimated savings

## Rules

- Compare against budgets in [budget-thresholds.md](references/budget-thresholds.md)
- Report gzipped sizes (what the browser downloads)
- Never auto-change dependencies — report and suggest only
