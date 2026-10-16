# Issue tracker: Jira

Specs and tickets live only as Jira work items in project `<KEY>`, via the Atlassian MCP. No `.specs/specs/` or `.specs/tickets/` files.

- **Site**: `getAccessibleAtlassianResources` → the `cloudId` every call below needs
- **Create**: `createJiraIssue` with project `<KEY>`, type Story for a spec and Task for a ticket (unless the project uses other types), summary, description in Markdown
- **Read**: `getJiraIssue <KEY-n>`
- **Update body**: `editJiraIssue <KEY-n>` with the new description
- **Comment**: `addCommentToJiraIssue <KEY-n>`
- **Child of the spec item**: set the spec as parent on create. Unsupported → `Part of <KEY-n>` at the top of the description.
- **Children**: `searchJiraIssuesUsingJql` with `parent = <KEY-n> ORDER BY created ASC`
- **Blocking**: `getIssueLinkTypes` → the "Blocks" type, then `createIssueLink`. Unavailable → `Blocked by: <KEY-n>` at the top of the description.
- **Blockers**: the "is blocked by" links in `getJiraIssue`, else the `Blocked by:` line
- **Close**: `addCommentToJiraIssue` with "Done in <sha>", then `getTransitionsForJiraIssue` → the Done transition, then `transitionJiraIssue`
- **PR closing keyword**: none. `Resolves <KEY-n>` in the PR body links it, but doesn't close it
- **Label**: `hitl` tickets → label `hitl`
- **Ref format**: `<KEY-n>`
