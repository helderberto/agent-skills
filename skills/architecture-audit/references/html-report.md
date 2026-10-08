# HTML Report (`--html`)

One HTML file in the OS temp dir: `$TMPDIR`, else `/tmp` (`%TEMP%` on Windows), named `architecture-audit-<timestamp>.html` so each run gets a fresh file. Open it (`open` on macOS, `xdg-open` on Linux, `start` on Windows) and print the absolute path. Nothing lands in the repo.

Tailwind (`https://cdn.tailwindcss.com`) and Mermaid (`https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs`) come from CDNs; those are the only scripts. Use Mermaid where the point is graph-shaped (call graphs, dependencies, sequences); hand-built divs or inline SVG where it is editorial (mass diagrams, cross-sections).

## Layout

- **Header**: repo name, date, a legend (solid box = module, dashed line = seam, red arrow = leak, thick dark box = deep module). No intro paragraph.
- **One `<article>` per candidate**:
  - Title naming the deepening ("Collapse the Order intake pipeline")
  - Badges: strength (`Strong` emerald, `Worth exploring` amber, `Speculative` slate) and dependency category
  - Files, monospaced
  - **Before / After diagram**, side by side, ~320px tall: the centrepiece
  - Problem: one sentence. Solution: one sentence.
  - Wins: bullets of ≤6 words, in glossary terms ("locality: bugs concentrate in one module")
  - ADR callout in an amber box, when the candidate reopens an ADR
- **Top recommendation**: one card, the candidate to tackle first, one sentence why, an anchor link to its card.

If a diagram needs a paragraph to be understood, redraw the diagram.

## Diagram patterns

Vary them across candidates:

- **Mermaid flowchart** for "X calls Y calls Z": `classDef` colours leaking edges red and the deep module dark. A sequence diagram suits "before: 6 round-trips; after: 1".
- **Boxes and arrows** in divs and SVG when the after state is one thick-bordered module with faded internals, which Mermaid can't weight right.
- **Cross-section**: stacked bands for the layers a call passes through. Before: six thin pass-through layers. After: one thick band.
- **Mass diagram**: interface rectangle beside implementation rectangle. Shallow: nearly equal. Deep: short interface, tall implementation.
- **Call-graph collapse**: nested call boxes before; one box with the calls faded inside after.

## Style

Editorial, not dashboard: generous whitespace, one accent colour plus red for leaks and amber for warnings, `text-xs uppercase tracking-wider` for module labels. Use the `codebase-design` terms exactly (module, interface, implementation, depth, seam, adapter, leverage, locality); never "component", "service", "API", or "boundary" in their place. Domain names come from `GLOSSARY.md`.
