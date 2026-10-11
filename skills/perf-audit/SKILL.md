---
name: perf-audit
description: Audit frontend bundle size and Core Web Vitals risks. Use when asked to "audit performance", "analyze bundle", "check bundle size", "check Core Web Vitals", or find frontend bottlenecks. Don't use for backend performance or database queries.
user-invocable: false
---

# Performance Audit

## Workflow

1. Detect build tool from `package.json` (vite, webpack, next, rollup)
2. Run the production build via the project's task runner (auto-detect from package.json).
3. Analyze the build output — non-interactive only. Never launch a browser or a long-running server in an audit; those hang an automated run. Prefer, in order:
   - **Measure the emitted files directly**: for each file in the output dir (e.g. `dist/assets/*.js`), report raw + gzipped size — `gzip -c <file> | wc -c`. This always works and needs no extra tooling.
   - **Per-module breakdown, as a static artifact** (not a server), written under `$TMPDIR` (else `/tmp`) and never the working tree, where the next `commit` would sweep it in. Print the path:
     - Vite/Rollup: `npx source-map-explorer 'dist/assets/*.js'`, or add `rollup-plugin-visualizer` configured to emit JSON/HTML to a file
     - webpack/Next.js: `npx webpack-bundle-analyzer -m static -r "${TMPDIR:-/tmp}/report.html" <stats-file>` (writes a file; do **not** use the default server mode)
   - `npx vite-bundle-visualizer` opens a browser and blocks — only suggest it to the user for manual exploration; do not run it here.

4. Check `package.json` for known heavy packages
5. Check the source for the [Core Web Vitals risks](#core-web-vitals-risks) below. Detect the framework first; recommend only its idioms.
6. Report findings: size impact for the bundle, potential impact for source risks

Compare against standard industry thresholds; report gzipped sizes.

## Core Web Vitals risks

Read the source for these; each is a `potential impact` until measured.

- **LCP**: hero image or heading not lazy-loaded; LCP image in the initial HTML with `fetchpriority="high"`; no `<head>` scripts without `defer`/`async`; critical fonts preloaded
- **CLS**: images, iframes, and embeds reserve space (`width`/`height` or `aspect-ratio`); nothing injected above existing content; fonts with `font-display` and matched fallbacks
- **INP**: no long synchronous work in event handlers; long loops yield (`scheduler.yield()`, `setTimeout` fallback); heavy work in a worker
- **Rendering**: long lists virtualized; animations on `transform`/`opacity`; no read-then-write layout loops; memoization only where it pays
- **Network**: independent requests in parallel, not sequential `await`s; no over-fetching; lists paginated; hashed static assets cached long; heavy third-party widgets behind a facade

## Output format

- **Bundle summary**: total size / gzipped size vs budget
- **Large chunks**: name + size + % of total
- **Heavy deps**: package + size + lighter alternative
- **Quick wins**: sorted by estimated savings
- **Core Web Vitals**: LCP, INP, CLS — value + source, or `not measured`
- **Source risks**: `file:line`, the metric at risk, the fix

## Rules

- Report gzipped sizes (what the browser downloads)
- Never auto-change dependencies -- report and suggest only
- Never state an LCP, INP, or CLS value without a measurement the user provided (Lighthouse or PageSpeed JSON, CrUX data, a DevTools trace); label it lab or field
- Skip micro-optimizations with no plausible effect on a Core Web Vital or the bundle

## Error Handling

- Build fails -- report the error, skip the bundle steps, still run the source checks
- No build output found -- run production build first
- Build tool unrecognized -- scan `package.json` for heavy packages, then run the source checks
