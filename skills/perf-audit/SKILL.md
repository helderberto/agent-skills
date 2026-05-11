---
name: perf-audit
description: Audit frontend bundle size and performance. Use when user asks to "audit performance", "/perf-audit", "analyze bundle", "check bundle size", or wants to find performance bottlenecks. Don't use for backend performance, database query optimization, or projects without a frontend build step.
---

# Performance Audit

## Workflow

1. Detect build tool from `package.json` (vite, webpack, next, rollup)
2. Run production build if no recent build exists:
   - Vite: `npm run build`
   - Next.js: `npm run build` (reads `.next/analyze/` if `ANALYZE=true`)
3. Analyze bundle output:

   **Vite:**
   ```bash
   npx vite-bundle-visualizer
   ```

   **webpack/Next.js:**
   ```bash
   npx webpack-bundle-analyzer <stats-file>
   ```

4. Check `package.json` for known heavy packages (see table below)
5. Report findings with size impact

## Budget Thresholds

| Asset | Good | Warning | Critical |
|---|---|---|---|
| Initial JS (gzip) | < 150 KB | 150-300 KB | > 300 KB |
| Initial CSS (gzip) | < 20 KB | 20-50 KB | > 50 KB |
| Individual chunk | < 50 KB | 50-100 KB | > 100 KB |
| Total page weight | < 500 KB | 500 KB-1 MB | > 1 MB |

## Heavy Packages

| Package | Size | Alternative | Savings |
|---|---|---|---|
| `moment` | ~230 KB | `date-fns` / `dayjs` | ~200 KB |
| `lodash` (full) | ~70 KB | `lodash/merge` or native | ~60 KB |
| `@mui/material` (full) | ~300 KB | Named imports | ~150 KB |
| `react-icons` (all) | variable | Import only used icon packs | varies |
| `axios` | ~15 KB | `ky` or native `fetch` | ~10 KB |

## Lighthouse Scores

| Metric | Good | Needs work | Poor |
|---|---|---|---|
| Performance | >= 90 | 50-89 | < 50 |
| FCP | < 1.8s | 1.8-3s | > 3s |
| LCP | < 2.5s | 2.5-4s | > 4s |
| TBT | < 200ms | 200-600ms | > 600ms |
| CLS | < 0.1 | 0.1-0.25 | > 0.25 |

## Output format

- **Bundle summary**: total size / gzipped size vs budget
- **Large chunks**: name + size + % of total
- **Heavy deps**: package + size + lighter alternative
- **Quick wins**: sorted by estimated savings

## Rules

- Compare against budget thresholds above
- Report gzipped sizes (what the browser downloads)
- Never auto-change dependencies -- report and suggest only

## Error Handling

- Build fails -- report the error and stop; fix build issues before auditing
- No build output found -- run production build first
- Build tool unrecognized -- fall back to scanning `package.json` for heavy packages only
