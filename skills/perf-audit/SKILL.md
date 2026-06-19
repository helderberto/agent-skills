---
name: perf-audit
description: Audit frontend bundle size and performance. Use when user asks to "audit performance", "/perf-audit", "analyze bundle", "check bundle size", or wants to find performance bottlenecks. Don't use for backend performance, database query optimization, or projects without a frontend build step.
---

# Performance Audit

## Workflow

1. Detect build tool from `package.json` (vite, webpack, next, rollup)
2. Run the production build via the project's task runner (auto-detect from package.json).
3. Analyze bundle output:

   **Vite:**
   ```bash
   npx vite-bundle-visualizer
   ```

   **webpack/Next.js:**
   ```bash
   npx webpack-bundle-analyzer <stats-file>
   ```

4. Check `package.json` for known heavy packages
5. Report findings with size impact

Compare against standard industry thresholds; report gzipped sizes.

## Output format

- **Bundle summary**: total size / gzipped size vs budget
- **Large chunks**: name + size + % of total
- **Heavy deps**: package + size + lighter alternative
- **Quick wins**: sorted by estimated savings

## Rules

- Report gzipped sizes (what the browser downloads)
- Never auto-change dependencies -- report and suggest only

## Error Handling

- Build fails -- report the error and stop; fix build issues before auditing
- No build output found -- run production build first
- Build tool unrecognized -- fall back to scanning `package.json` for heavy packages only
