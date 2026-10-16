# Issue tracker: GitHub

Specs and tickets live only as GitHub issues in this repo, via the `gh` CLI. No `.specs/specs/` or `.specs/tickets/` files.

- **Create**: `gh issue create --title "..." --body-file <tmp>`
- **Read**: `gh issue view <n> --json number,title,body,labels,state,comments`
- **Update body**: `gh issue edit <n> --body-file <tmp>`
- **Comment**: `gh issue comment <n> --body-file <tmp>`
- **Child of the spec issue**: `gh issue create --parent <n> ...` (`gh` 2.94+). Older `gh` → `Part of #<n>` at the top of the body.
- **Children**: `gh api repos/{owner}/{repo}/issues/<n>/sub_issues --jq '.[] | {number,title,state}'`, in creation order
- **Blocking**: `gh api --method POST repos/{owner}/{repo}/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where the db id is `gh api repos/{owner}/{repo}/issues/<n> --jq .id`. Unavailable → `Blocked by: #<n>` at the top of the body.
- **Blockers**: `gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by --jq '.[] | {number,state}'`, else the `Blocked by:` line
- **Close**: `gh issue close <n> --comment "Done in <sha>"`
- **PR closing keyword**: `Closes #<n>` in the PR body closes the issue on merge
- **Label**: `hitl` tickets → `--label hitl`
- **Ref format**: `#<n>`
