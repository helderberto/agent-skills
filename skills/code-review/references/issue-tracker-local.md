# Issue tracker: local markdown

The default when `.specs/issue-tracker.md` is missing. Specs and tickets are markdown files under `.specs/`.

- A spec is `.specs/specs/<slug>.md`. A split spec is one `<slug>-<part>.md` per part, opening with `**Parent**: <slug>`.
- Tickets are `.specs/tickets/<slug>.md`, written from the `to-tickets` template. Update it in place, keeping ticked boxes.
- A ticket is done when every box is ticked. Nothing to close, no commit or PR refs.
