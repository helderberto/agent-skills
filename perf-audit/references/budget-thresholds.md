# Performance Budget Thresholds

## Bundle size budgets

| Asset | Good | Warning | Critical |
|---|---|---|---|
| Initial JS (gzipped) | < 150 KB | 150–300 KB | > 300 KB |
| Initial CSS (gzipped) | < 20 KB | 20–50 KB | > 50 KB |
| Individual chunk | < 50 KB | 50–100 KB | > 100 KB |
| Total page weight | < 500 KB | 500 KB–1 MB | > 1 MB |

## Common heavy packages and alternatives

| Package | Typical size | Alternative | Savings |
|---|---|---|---|
| `moment` | ~230 KB | `date-fns` or `dayjs` | ~200 KB |
| `lodash` (full) | ~70 KB | Named imports `lodash/merge` or native | ~60 KB |
| `@mui/material` (full import) | ~300 KB | Named imports | ~150 KB |
| `react-icons` (all) | variable | Import only used icon packages | varies |
| `axios` | ~15 KB | `ky` or native `fetch` | ~10 KB |

## Vite bundle analysis

```bash
# Quick: summary in terminal
npx vite-bundle-visualizer --reporter json

# Visual: opens browser treemap
npx vite-bundle-visualizer
```

## Next.js bundle analysis

```bash
# Add to next.config.js:
# const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: true })

ANALYZE=true npm run build
```

## webpack

```bash
# Generate stats file
npx webpack --profile --json > stats.json

# Visualize
npx webpack-bundle-analyzer stats.json
```

## Lighthouse scores

| Metric | Good | Needs improvement | Poor |
|---|---|---|---|
| Performance | ≥ 90 | 50–89 | < 50 |
| FCP | < 1.8s | 1.8–3s | > 3s |
| LCP | < 2.5s | 2.5–4s | > 4s |
| TBT | < 200ms | 200–600ms | > 600ms |
| CLS | < 0.1 | 0.1–0.25 | > 0.25 |
