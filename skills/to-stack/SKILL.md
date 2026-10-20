---
name: to-stack
description: Split a large branch or PR into a stack of small PRs, each based on the one below, rebuilt from the final tree and verified layer by layer, then push and open them with linked bodies.
argument-hint: '[PR | branch] [--each]'
disable-model-invocation: true
effort: high
---

# Split

Turn one large change into a **stack**: PR 1 on the base branch, each later PR on the one below it. Reviewers read one concern at a time, and the top of the stack is byte-for-byte the tree you already tested.

Arguments: $ARGUMENTS

- A PR number or URL, or a branch. None → the current branch and its PR.
- `--each` — land each PR on the base in order, each with its own version bump and CHANGELOG section. Default: merge from the top down into PR 1, which lands as one squash and one release.

## Workflow

1. **Resolve.**
   - Dirty tree → stop and ask to commit or stash.
   - A PR → `gh pr view <PR> --json headRefName,baseRefName`, then `gh pr checkout <PR>`. A branch → check it out. Its head is `<tip>`; its base is the PR's `baseRefName`, else the default branch.
   - `git fetch origin <base>`, then diff against the remote base, since a stale local base inflates the diff: `git diff --stat origin/<base>...<tip>` and `git log --oneline origin/<base>..<tip>`.
   - Tip conflicts with the base, or the base already released the planned version → merge the base in and bump first. A collision belongs to the whole change, not to one layer.
   - Under ~600 changed lines without lockfiles → say a split isn't worth it, and stop unless the user insists.

   Done when the scope is stated: "Splitting `feat/x` (#42) vs `main`: 49 files, +3432".

2. **Map.** Record what every changed file needs: its imports, and for each test case the mocks, globals, helpers and options it touches. Group the changes into concerns. For shared files (manifest, entry barrel, types index, core module, README, CHANGELOG), assign each changed line to a concern. Done when every changed line has an owner. Ownership rules: [references/layering.md](references/layering.md).

3. **Plan.** Order the concerns so each layer depends only on layers below it: manifest and config first, then the core, then features, then deprecated or compatibility code, so a future major deletes one layer. Each layer is **tight**:
   - one concern, under ~600 changed lines without lockfiles
   - green on its own
   - nothing in it waits on a later layer to be used: move a reader with its writer

   Present a table of layer, branch, contents, approximate lines and base, plus the merge strategy. An existing PR becomes PR 1, and its branch gets rewritten. Wait for an unambiguous yes. It covers building, pushing (`--force-with-lease` for the rewritten branch) and opening the PRs.

4. **Back up.** Run `git branch <branch>-full <tip>`. Every later check compares against it. Done when the backup points at the tip.

5. **Build bottom-up.** For each layer, on a new branch from the one below:
   - Files that land whole: `git restore --source=<backup> --staged --worktree -- <paths>`, listing both sides of a rename. Unlike `git checkout`, it also applies deletions.
   - Shared files: write only this layer's slice. In tests, keep the final cases this layer can run. If a core behavior would go untested, write the smallest stand-in case; a later layer restores the final version.
   - Manifest: only this layer's fields, then regenerate the lockfile (`npm install --package-lock-only --ignore-scripts`, or the repo's equivalent). The version bump goes in layer 1. With `--each`, each layer bumps from the one below by its own change type, so the top's version can be above the backup's.
   - Docs: only this layer's README and CHANGELOG lines, under the one version heading, or the layer's own heading with `--each`.
   - Stage explicit paths. Delete any generated output the base doesn't ignore yet, such as build shims, before the checks.
   - Call the Skill tool with `check`. Commit only if it's green: chain with `&&`. One conventional commit per layer.

   Done when every layer has its commit and `check` passed on that exact tree.

6. **Verify the stack.** `git diff --quiet <backup> <top>` must pass, because the top layer is the original tree. With `--each`, run it with `-- . ':!<manifest>' ':!<lockfile>' ':!CHANGELOG.md'`, then check that `git diff <backup> <top> -- <manifest> <lockfile> CHANGELOG.md` shows only version lines and version headings. If it fails, find the layer that lost or gained lines, fix it there, and restack as in step 7. Done when the diff is empty.

7. **Fold in fixes**, only when the user asked for changes along with the split.
   - Commit each fix on the layer that owns the code.
   - Restack everything above it: `git rebase --update-refs --onto <layer> <layer>@{1} <top>`.
   - When adjacent edits conflict, keep both sides' intent.
   - Then check that each layer's files outside the fix still match the tree that passed `check`: `git diff <green-sha> <layer> -- . ':!<fix paths>'`.

   Done when the top differs from the backup by exactly the fixes.

8. **Open the drafts.**
   - Push each layer branch with `-u`, and the rewritten PR 1 branch with `--force-with-lease`.
   - Bottom-up, skip a layer that already has a PR: `gh pr list --head <branch> --state open`.
   - Otherwise run `gh pr create --draft --base <layer below> --head <branch> --title <title> --body "Part N of M"`. PR 1's base is the base branch.
   - Record each PR number from the printed URL.

   Done when every layer has a PR whose base is the layer below.

9. **Write the bodies.** One per layer, on the repo's PR template (`.github/pull_request_template.md` or its variants). Each body holds:
   - `Part N of M` and a one-sentence summary
   - the stack as a numbered list of the PR numbers, with `← this PR`
   - what the layer adds
   - review notes on anything that arrives in a later layer
   - the evidence from step 5

   - Default: PR 1 keeps the whole-change description, because its squash is what lands, with the stack and "this PR's own diff" on top. Retitle it to the whole change with `--title`.
   - `--each`: PR 1 lands alone, so its body and title cover its own layer, like the others.

   Apply each body with `gh pr edit <n> --body-file <file>`.

   Done when every PR body links the whole stack.

## Report

A table of `# | PR | Branch | Lines | Tests`, then how to land it:

- Review from PR 1 up.
- Default: merge from the top down, squashing each PR into the one below. PR 1 merges to the base last, so no layer needs a rebase.
- `--each`: merge PR 1 into the base, then rebase PR 2 onto the squashed commit (`git fetch origin <base>`, then `git rebase --onto origin/<base> <old PR 1 tip> <PR 2>`) and retarget it, and so on up the stack.
- A fix on a lower layer: commit it there, restack with `--update-refs`, and push the layers above with `--force-with-lease`.
- Keep the backup branch until PR 1 merges.

Next: `/hb:feedback <PR 1>` once reviews arrive.
