# Issue tracker: GitHub

Specs and tickets are GitHub issues in this repo, via `gh`. Nothing goes in `.specs/specs/` or `.specs/tickets/`.

- A spec is one issue; a split spec is one sub-issue per part. Its tickets are sub-issues, created in dependency order, labelled `hitl` where needed. Shared decisions, out of scope, and open questions go in one comment on the spec.
- Blockers use native links: `gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by` (POST `-F issue_id=<blocker .id>`; GET to list). Children: `.../issues/<n>/sub_issues`.
- Tick boxes by editing the issue body. A ticket is done when closed.
- Commit subjects end with `(#n)`. After a ticket's commit, close it with a "Done in <sha>" comment. On a feature branch, `Closes #n` in the PR closes it on merge instead.
