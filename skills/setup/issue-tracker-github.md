# Issue tracker: GitHub

Specs and tickets are GitHub issues in this repo, via `gh` (2.102+). Nothing goes in `.specs/specs/` or `.specs/tickets/`.

- A spec is one issue; a split spec is one sub-issue per part. Tickets are sub-issues created in dependency order: `gh issue create --parent <spec> --blocked-by <n,…> --label hitl`. Shared decisions, out of scope, and open questions go in one `gh issue comment` on the spec.
- Read tickets with `gh issue view <spec> --json subIssues`, then `gh issue view <n> --json body,state,blockedBy`.
- Tick boxes with `gh issue edit <n> --body-file <tmp>`. A ticket is done when closed.
- Commit subjects end with `(#n)`. After a ticket's commit, `gh issue close <n> --comment "Done in <sha>"`. On a feature branch, `Closes #n` in the PR closes it on merge instead.
