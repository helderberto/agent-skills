# Issue tracker: Jira

Specs and tickets publish as Jira work items in project `<KEY>`, via the `acli` CLI, else the Atlassian MCP.

- **Create**: `acli jira workitem create --project <KEY> --type <Story|Task> --summary "..." --description-file <tmp>`. Spec → Story, ticket → Task, unless the project uses other types.
- **Read**: `acli jira workitem view <KEY-n>`
- **Child of the spec item**: set the spec as parent. Unsupported → `Part of <KEY-n>` at the top of the description.
- **Blocking**: native "Blocks" link. Unavailable → `Blocked by: <KEY-n>` at the top of the description.
- **Label**: `hitl` tickets → label `hitl`
- **Ref format**: `<KEY-n>`
