# Issue tracker: GitHub

Specs and tickets live only as GitHub issues in this repo, via the `gh` CLI. No `.specs/specs/` or `.specs/tickets/` files.

- **Publish spec**: `gh issue create --title "<feature>" --body-file <tmp>`. Updating → `gh issue edit <n> --body-file <tmp>`.
- **Read**: `gh issue view <n> --json number,title,body,labels,state,comments`
- **Publish tickets**:
  1. `gh issue comment <spec> --body-file <tmp>` with the Architectural Decisions, Out of Scope, and Open Questions sections.
  2. Per ticket, in dependency order: `gh issue create --parent <spec> --title "<goal>" --body-file <tmp>`, body = user stories, what it delivers, criteria. `hitl` → `--label hitl`. Older `gh` without `--parent` → `Part of #<spec>` at the top of the body.
  3. Blockers: `gh api --method POST repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by -F issue_id=<id>`, where the id is `gh api repos/{owner}/{repo}/issues/<blocker> --jq .id`. Unavailable → `Blocked by: #<n>` at the top of the body.
  4. A rerun skips titles already among the children. Updating a ticket → `gh issue edit`.
- **List tickets**: `gh api repos/{owner}/{repo}/issues/<spec>/sub_issues --jq '.[] | {number,title,state}'` in creation order, then **Read** each for its boxes, and `gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by --jq '.[] | {number,state}'` for blockers. Decisions: the spec's comment. Done = closed.
- **Tick boxes**: edit the body, then `gh issue edit <n> --body-file <tmp>`.
- **Close ticket**: `gh issue close <n> --comment "Done in <sha>"`. On a feature branch, leave it open: the **PR link** closes it on merge.
- **Split spec**: one child issue of the spec per part, in dependency order, with blocking links.
- **Commit ref**: `(#<n>)` at the end of the subject.
- **PR link**: `Closes #<n>`
- **Ref format**: `#<n>`
