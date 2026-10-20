---
name: to-release
description: Prepare a library release on its PR (version, changelog, draft GitHub release) for review, then tag and publish it after you merge.
disable-model-invocation: true
argument-hint: '[PR-number] [--pre alpha|beta|rc]'
---

# To Release

For libraries and other versioned packages. One command, two runs; the PR's state picks the phase: open → **prepare**, merged → **publish**. You review and merge in between. This skill never merges.

## 1. Resolve

`gh auth status` fails → stop: "Run `! gh auth login`, then `/hb:to-release` again." PR from `$ARGUMENTS`, else the current branch's: `gh pr view <PR> --json number,state,headRefName,baseRefName,mergeCommit,title,body`. Closed unmerged → stop.

Versions follow [semver](https://semver.org): `MAJOR.MINOR.PATCH`, pre-releases `X.Y.Z-<id>.N` with `alpha` < `beta` < `rc` < the release. `git fetch origin --tags`, then sort with `git -c versionsort.suffix=- tag --sort=-v:refname`: plain `v:refname` ranks `1.0.0` below its own `-rc`. The first line is the previous tag; the first without a `-` suffix is the previous stable. New tags match their format (`v1.2.3` or `1.2.3`). No tag yet → first release at the manifest version.

## Prepare (PR open)

2. **Checks**: `gh pr checks <PR>` red or pending → stop and report.
3. **Version**: a manifest in the PR (`package.json`, `.claude-plugin/plugin.json`, `Cargo.toml`, `pyproject.toml`, …) is ahead of the previous tag → use it. Otherwise:
   - Base bump from the commits since the previous stable: `!` or `BREAKING CHANGE` → major, `feat` → minor, else patch. Below `1.0.0`, major becomes minor.
   - `--pre <id>`: previous tag is a pre-release of the same base → same `<id>` increments `N`, a later `<id>` restarts at `.0`, an earlier one stops and reports. Otherwise apply the base bump, then `-<id>.0`.
   - No `--pre` and the previous tag is a pre-release → promote its base (`1.0.0-rc.2` → `1.0.0`).

   Bump every file that carries the version, including copies the repo's docs require, in each file's own syntax (PEP 440 writes `1.0.0a0`; the tag stays semver), and commit `chore(release): <tag>`. Done when every version-bearing file reads the new version.
4. **Changelog**: `CHANGELOG.md` exists without an entry for this version → prepend one in its format and commit. No file → the release notes are the changelog; don't create one.
5. **Notes**: shaped like the previous release (`gh release view <previous> --json name,body`): its title, sections, voice, and closing PR ref. Write them from the PR body and the commits since the previous tag; a stable release spans everything since the previous stable, pre-releases included. No previous release → `## Added` / `## Changed` / `## Fixed`, empty ones omitted.
6. **Draft**: `gh release create <tag> --draft --title <title> --notes-file <file>`, plus `--prerelease` for a pre-release so it never becomes Latest; a draft for this tag exists → `gh release edit <tag> --notes-file <file>`. A draft creates no tag. Push the branch.

Stop with the version, the PR URL, and the draft URL: "Review the PR and the draft release, merge, then `/hb:to-release <PR>` again."

## Publish (PR merged)

The tag is the version the files carry at `mergeCommit`. Not ahead of the previous tag → stop: the bump never merged. No draft for it → write the notes per step 5 first.

7. **Automation**: find who publishes. A workflow on `release: published` → publish below; it runs after. A workflow that creates the release on `push: tags`, or release-please, changesets, semantic-release, or goreleaser config → it owns the release: delete the draft, push the tag only, watch its run.
8. **Confirm once**: the tag, the merge commit (sha + title), and the draft's notes re-read with `gh release view <tag> --json body`, so your edits survive. This is the only question.
9. **Tag**: annotated, on `mergeCommit`, one line per change the notes span: `git tag -a <tag> <sha> -F <file>`, then `git push origin <tag>`. The tag already exists on that commit → skip. On another commit → stop and report; never move a pushed tag.
10. **Publish**: `gh release edit <tag> --draft=false --verify-tag`. Already published → skip.
11. **Watch**: a workflow the tag or release triggered → `gh run watch`. Red → report the failing job; don't retry.

Return the release URL.

Next: `/hb:retro` in this session, before `/clear`.
