# Issue tracker: local markdown

The default when `.specs/issue-tracker.md` is missing. Specs and tickets are files under `.specs/`.

- **Publish spec**: write `.specs/specs/<slug>.md`. Exists → update it in place.
- **Read**: the spec or tickets file by slug.
- **Publish tickets**: write `.specs/tickets/<slug>.md` from the `to-tickets` template. Exists → update it in place, keeping ticked boxes.
- **List tickets**: the `## Ticket N` sections of `.specs/tickets/<slug>.md`, with their boxes and `**Blocked by**`. Done = every box ticked.
- **Tick boxes**: flip `- [ ]` → `- [x]` in the tickets file.
- **Close ticket**: nothing; ticked boxes mark it done.
- **Split spec**: one file per part, `.specs/specs/<slug>-<part>.md`, opening with `**Parent**: <slug>`.
- **Commit ref**: none.
- **PR link**: none.
- **Ref format**: the slug.
