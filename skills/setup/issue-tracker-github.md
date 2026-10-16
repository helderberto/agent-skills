# Issue tracker: GitHub

Specs and tickets publish as GitHub issues in this repo, via the `gh` CLI.

- **Create**: `gh issue create --title "..." --body-file <tmp>`
- **Read**: `gh issue view <n> --json number,title,body,labels,comments`
- **Sub-issue of the spec issue**: `gh issue create --parent <n> ...` (`gh` 2.94+). Older `gh` → `Part of #<n>` at the top of the body.
- **Blocking**: `gh api --method POST repos/{owner}/{repo}/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, where the db id is `gh api repos/{owner}/{repo}/issues/<n> --jq .id`. Unavailable → `Blocked by: #<n>` at the top of the body.
- **Label**: `hitl` tickets → `--label hitl`
- **Ref format**: `#<n>`
