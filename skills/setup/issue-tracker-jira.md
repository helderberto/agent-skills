# Issue tracker: Jira

Specs and tickets publish as Jira work items in project `<KEY>`, via the Atlassian MCP.

- **Site**: `getAccessibleAtlassianResources` → the `cloudId` every call below needs
- **Create**: `createJiraIssue` with project `<KEY>`, type Story for a spec and Task for a ticket (unless the project uses other types), summary, description in Markdown
- **Read**: `getJiraIssue <KEY-n>`
- **Child of the spec item**: set the spec as parent on create. Unsupported → `Part of <KEY-n>` at the top of the description.
- **Blocking**: `getIssueLinkTypes` → the "Blocks" type, then `createIssueLink`. Unavailable → `Blocked by: <KEY-n>` at the top of the description.
- **Label**: `hitl` tickets → label `hitl`
- **Close**: `addCommentToJiraIssue` with "Done in <sha>", then `getTransitionsForJiraIssue` → the Done transition, then `transitionJiraIssue`
- **PR closing keyword**: none. `Resolves <KEY-n>` in the PR body links it, but doesn't close it
- **Ref format**: `<KEY-n>`
