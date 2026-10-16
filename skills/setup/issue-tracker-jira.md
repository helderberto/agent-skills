# Issue tracker: Jira

Specs and tickets are Jira items in project `<KEY>`, via the Atlassian MCP. Nothing goes in `.specs/specs/` or `.specs/tickets/`.

- A spec is one Story; a split spec is one child per part. Its tickets are child Tasks, created in dependency order, labelled `hitl` where needed, linked with the "Blocks" link type. Shared decisions, out of scope, and open questions go in one comment on the spec.
- Tick boxes by editing the description. A ticket is done in the Done status.
- Commit subjects start with `<KEY-n>`. After a ticket's commit, comment "Done in <sha>" and transition it to Done, on any branch: a PR merge can't close it. PRs say `Resolves <KEY-n>`.
