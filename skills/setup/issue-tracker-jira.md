# Issue tracker: Jira

Specs and tickets live only as Jira work items in project `<KEY>`, via the Atlassian MCP. No `.specs/specs/` or `.specs/tickets/` files. Every call needs the `cloudId` from `getAccessibleAtlassianResources`.

- **Publish spec**: `createJiraIssue` in `<KEY>`, type Story (unless the project uses other types), description in Markdown. Updating → `editJiraIssue`.
- **Read**: `getJiraIssue <KEY-n>`
- **Publish tickets**:
  1. `addCommentToJiraIssue` on the spec with the Architectural Decisions, Out of Scope, and Open Questions sections.
  2. Per ticket, in dependency order: `createJiraIssue`, type Task, parent = the spec, description = user stories, what it delivers, criteria. `hitl` → label `hitl`. Parent unsupported → `Part of <KEY-n>` at the top.
  3. Blockers: `getIssueLinkTypes` → "Blocks", then `createIssueLink`. Unavailable → `Blocked by: <KEY-n>` at the top.
  4. A rerun skips summaries already among the children. Updating a ticket → `editJiraIssue`.
- **List tickets**: `searchJiraIssuesUsingJql` with `parent = <KEY-n> ORDER BY created ASC`, then **Read** each for its boxes and "is blocked by" links. Decisions: the spec's comment. Done = Done status.
- **Tick boxes**: `editJiraIssue` with the updated description.
- **Close ticket**: `addCommentToJiraIssue` "Done in <sha>", then `getTransitionsForJiraIssue` → Done, then `transitionJiraIssue`. Any branch: a PR merge can't close it.
- **Split spec**: one child item of the spec per part, in dependency order, with blocking links.
- **Commit ref**: `<KEY-n>` at the start of the subject.
- **PR link**: `Resolves <KEY-n>`, a link only.
- **Ref format**: `<KEY-n>`
