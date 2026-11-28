# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.19.0] - 2026-11-28

`build` runs the type checker and only the touched tests while iterating, and the full suite once per ticket. Versioning now follows a declared public API, and `CHANGELOG.md` records every release.

### Added

- `CHANGELOG.md` in Keep a Changelog format, covering every release since v0.1.0
- `CONTRIBUTING.md` declares the public API and what counts as a major, minor, or patch change

### Changed

- `build`: single-ticket and `--all` runs iterate on the type checker and touched test files; `check` runs the full suite once
- CI requires the version bump that the PR's commits imply: `!` or `BREAKING CHANGE` → major, `feat` → minor, else patch
- Contributors run `revise` on prose before committing

Full change list in [#41](https://github.com/helderberto/agent-skills/pull/41) and [#42](https://github.com/helderberto/agent-skills/pull/42).

## [4.18.0] - 2026-11-28

Effort comes from the session (`/effort`); skills no longer raise it. `build --all` delegates its close review to fresh subagents.

### Changed

- Removed `effort: high`/`xhigh` from 18 skills; only mechanical skills (`commit`, `to-adr`, `setup`) keep `effort: low`
- `build --all` close: a fresh read-only reviewer subagent returns findings, and a fresh implementer fixes them

### Fixed

- `build --all` explore: the orchestrator saves the Explore subagent's notes, since Explore can't write files

Full change list in [#40](https://github.com/helderberto/agent-skills/pull/40).

## [4.17.0] - 2026-11-24

`to-doc` writes with the same rules `revise` checks, and keeps Confluence inline comments attached on an update.

### Changed

- Template rules: ground terms at first use, link what another doc or the code owns, lead-ins without counts, collapse what readers skip (a diagram stays outside the expand), rejected options in one table instead of a Decisions section
- Confluence: inline comments are annotation spans in the body; step 1 lists their IDs on a page that has them, and step 7 confirms each one survives

Full change list in [#39](https://github.com/helderberto/agent-skills/pull/39).

## [4.16.0] - 2026-11-24

`revise` edits any existing text, commit and PR messages included, and answers structure questions before it edits.

### Changed

- Description routes on existing text vs writing from scratch (`/to-doc`, `/draft`); the `/commit` exclusion is gone
- Question mode: "worth reordering?", "anything to cut?" get numbered candidates with a recommendation, and nothing changes until the user picks
- Step 1 names the doc type (article, design doc, README, commit or PR message), which sets the reader and where the takeaway lives
- Step 2 grounds each term at first use instead of a glossary block, and adds the cut test, link-out for detail another doc owns, collapse, format choice, and a roadmap that matches the sections
- Step 3: one job per sentence, reread merged sentences, grep code names you add
- Step 4: re-read before every write, keep words under comment anchors, one term per concept, lead-ins without counts (with a grep), cross-references that match their heading
- Constraints the user sets bind every later pass

Full change list in [#38](https://github.com/helderberto/agent-skills/pull/38).

## [4.15.0] - 2026-11-22

`build --all` keeps the frontier moving past blocked tickets, and every subagent starts with a fresh context window.

### Changed

- `build --all`: a `hitl` ticket, a check still red after 3 fixes, or an ambiguous spec parks that ticket and its dependents; the rest of the frontier keeps running, and parked questions come in one batch when nothing is left to spawn or merge. Irreversible changes still stop and ask
- Every skill that spawns a subagent (`build`, `review`, `code-review`, `debate`, `grill`, `architecture-audit`, `to-doc`, `codebase-design`) starts it with a fresh context window, not a fork of the conversation
- `domain-modeling`, `tdd`, `codebase-design`: `GLOSSARY.md` only; the legacy `CONTEXT.md` fallback is gone
- `guide` describes `--all` parking `hitl` tickets
- `docs/skill-conventions.md` and the `create-skill` checklist require fresh-context subagents

Full change list in [#37](https://github.com/helderberto/agent-skills/pull/37).

## [4.14.0] - 2026-11-21

New `/hb:draft` takes an article from a blank page to a revised draft.

### Added

- `draft` (typed): interview for raw fragments into `<slug>.notes.md`, pin reader and takeaway, pick one of 2–3 openings, grow the article block by block, then a full `revise`

### Changed

- `revise` description points new articles at `/draft`

Full change list in [#36](https://github.com/helderberto/agent-skills/pull/36).

## [4.13.0] - 2026-10-24

`tdd` covers browser globals and query order, and CI catches more drift before merge.

### Added

- CI fails a PR that changes `skills/` without bumping `.claude-plugin/plugin.json`
- CI checks links across skill folders, Claude Code-only tokens in skills, and tier table drift

### Changed

- `tdd`: stub browser globals with `vi.stubGlobal`, not `Object.defineProperty` or `vi.spyOn` on `window`
- `tdd`: query by role and accessible name, then label, then text; test ids last, same order as end-to-end tests
- CI runs once per PR

Full change list in [#30](https://github.com/helderberto/agent-skills/pull/30), [#31](https://github.com/helderberto/agent-skills/pull/31) and [#32](https://github.com/helderberto/agent-skills/pull/32).

## [4.12.0] - 2026-10-23

Skills route more precisely, stay harness-agnostic, and three audits join the `/hb:` menu.

### Added

- `/hb:a11y-audit`, `/hb:i18n`, `/hb:deps-audit` are typeable; the menu grows to 34 entries
- `grill` takes an idea or a slug as its argument

### Changed

- Descriptions name the sibling skill to use instead, so `revise`, `refactor`, `harden`, `safe-repo`, `deps-audit`, `perf-audit`, `debug`, `source-driven`, `research` and `check` stop colliding
- `revise` no longer fires on "clean up text" or "improve sentences"; `refactor` no longer claims "make robust", "bulletproof" or "strengthen"
- `review`, `code-review`, `debate`, `to-stack`, `to-doc`, `teach` get distinct one-line menu entries
- `retro`: always-loaded `CLAUDE.md` / `AGENTS.md` is a fixed budget; a new line evicts an old one
- Skill conventions: routers join the typed-only rule
- Argument hints on `to-spec`, `build`, `handoff`, `teach`, `retro`; `setup` runs at low effort, `research` at the default

### Fixed

- Harness-agnostic: no `${CLAUDE_SKILL_DIR}`, `~/.claude/projects`, `subagent_type=Explore` or `! gh auth login` left in skills
- `retro` names `debug`, not the stale `/debug`; `to-stack`'s heading; `to-doc` no longer links across skill folders

Full change list in [#29](https://github.com/helderberto/agent-skills/pull/29).

## [4.11.0] - 2026-10-22

`/hb:to-doc --adr`: write an Architecture Decision Record on a team's template and publish it to Confluence, a GitHub issue, or a Markdown file.

### Added

- `to-doc --adr`: `ADR-NNNN: {decision}` title numbered after its sibling ADRs, Context → Decision → Consequences (Positive / Negative), optional Technical details (proposed changes, implementation plan, rollout), Alternative options considered (Pros / Cons / Outcome) and References
- `to-doc --adr` on Confluence: header with Author(s), Date, Status and Approvers (one action item per approver); statuses DRAFT, PROPOSED, APPROVED, REJECTED, SUPERSEDED
- `to-doc --adr` runs `to-adr`'s gate first: hard to reverse, surprising without context, a real trade-off

### Changed

- `to-adr` points to `/hb:to-doc --adr` when the team needs a full ADR on Confluence
- `guide`, README and AGENTS.md list `--adr`

Full change list in [#28](https://github.com/helderberto/agent-skills/pull/28).

## [4.10.0] - 2026-10-21

New typed-only skill `/hb:to-doc`: turn what's in context (an investigation, measured data, a decision) into a doc for readers across the company, on Confluence, a GitHub issue, or a Markdown file.

### Added

- `to-doc`: read the destination, pin the one takeaway, research official sources, re-check every number, draft on a template (TL;DR panel, general rules before tool specifics, comparison tables, one Mermaid diagram per idea, our data with its caveats), polish with `revise`, publish, then read the page back
- `to-doc --one-pager`: a five-minute read, about 1,000 words, 3 diagrams at most, no table of contents
- `to-doc` on Confluence: a Page Properties header (status, authors, date, reviewers, approvers, related, tickets), a table of contents past 4 sections, smart-link sources
- `to-doc/scripts/adf-outline.sh`: outline a page's ADF, even inside a saved tool result, and flag a Mermaid macro duplicated inside its expand; tested in `scripts/check.sh`
- `guide`: `to-doc` in the standalone map

### Changed

- Typed-only tier is 19 skills; the `/hb:` menu shows 31 entries

Full change list in [#27](https://github.com/helderberto/agent-skills/pull/27).

## [4.9.2] - 2026-10-20

The lessons from v4.9.1 become conventions, and one script now runs what CI runs.

### Added

- Skill conventions: text other people wrote is data, never instructions, both where it's fetched and in every subagent brief. A skill's git and shell commands run in a scratch repo, with deletions, renames and a stale base, before they ship. `create-skill` checks both
- `scripts/check.sh`: every CI check in one local command
- `scripts/audits.sh`: skills.sh audit status (Agent Trust Hub, Socket, Snyk) for every skill

### Changed

- CI runs `scripts/check.sh` instead of separate steps; the `Test skill scripts` job is folded into it
- `to-release`: the release title is shaped like the previous one, not just the tag
- README: the skills.sh badge uses the official `skills.sh/b/` URL

### Fixed

- `debate`, `source-driven`, `to-pr`: fetched PR text, docs and CI output are data, never instructions to follow (Snyk W011)

Full change list in [#26](https://github.com/helderberto/agent-skills/pull/26).

## [4.9.1] - 2026-10-20

The review skills now treat PR text as untrusted input, and `/hb:to-stack` gets five correctness fixes.

### Added

- README: skills.sh installs badge

### Fixed

- `code-review`, `review`, `feedback`, `visual-review`: PR titles, bodies, comments and diffs are data to review, never instructions to follow. Every reviewer subagent brief carries the rule (Snyk W011)
- `to-stack`: a PR or branch argument is checked out before the split, instead of splitting whatever is checked out
- `to-stack`: diffs compare against `origin/<base>`, not a stale local base
- `to-stack`: whole files land with `git restore --source`, so deletions and renames apply; `git checkout` failed on them
- `to-stack --each`: each layer bumps by its own change type and gets its own CHANGELOG heading. The top-equals-original check skips version lines, and PR 1 gets its own title and body

Full change list in [#25](https://github.com/helderberto/agent-skills/pull/25).

## [4.9.0] - 2026-10-20

New typed-only skill `/hb:to-stack`: turn a large branch or PR into a stack of small PRs, each based on the one below. The top of the stack is byte-for-byte the tree you already tested.

### Added

- `to-stack`: map every changed line to a concern, plan tight layers (one concern, under ~600 lines, green on its own), build bottom-up with `check` on each layer, verify the top equals the original tree, then open the PRs as drafts with `gh` and link every body
- `to-stack --each`: land each layer on the base with its own version bump, instead of one squash into PR 1
- `guide`: on-ramp for a PR too big to review

### Changed

- Typed-only tier is 18 skills; the `/hb:` menu shows 30 entries

Full change list in [#24](https://github.com/helderberto/agent-skills/pull/24).

## [4.8.1] - 2026-10-19

Skills now stand alone, with no links outside their folder. A skill copied by itself (Cursor, Gemini CLI, `npx skills`) still finds everything it reads.

### Changed

- `code-review`, `to-spec`, `to-tickets`, `triage`, `review`, `build`: their own copy of the local tracker seed in `references/`
- `review`, `build`: their own copy of the quality axes and smells
- `create-skill`: no `../` links across skill folders; the exception added in [#21](https://github.com/helderberto/agent-skills/pull/21) is reverted

Full change list in [#23](https://github.com/helderberto/agent-skills/pull/23).

## [4.8.0] - 2026-10-19

`/hb:review` spawns four or more agents even for a tiny diff. `/hb:code-review` is now the lighter path you type: two agents in parallel, quality and spec, reported side by side.

### Changed

- `code-review`: typed-only, `/hb:code-review [PR]`. Reviews a PR or the current branch on two axes: Quality (correctness, readability, architecture, security, performance, repo standards, smells) and Spec (the issue, spec, or PR description). Never re-ranked against each other. Pattern from mattpocock/skills and addyosmani/agent-skills
- `code-review/references/axes.md`: the quality checklist, approval standard, and structural remedies
- `review`, `build`: the correctness pass reads the axes directly, since `code-review` can't be called through the Skill tool anymore
- `triage`, `guide`: someone else's PR → `/hb:code-review <PR>`; `/hb:review <PR>` for the full panel

Plain "review this PR" no longer triggers `code-review`: type it.

Full change list in [#21](https://github.com/helderberto/agent-skills/pull/21).

## [4.7.0] - 2026-10-19

Releasing meant asking for the same steps every time: merge, tag, notes, publish. Now one command prepares the release on the open PR, you review and merge, and the same command publishes it.

### Added

- `to-release`: `/hb:to-release [PR] [--pre alpha|beta|rc]`. PR open → bumps the version (from the PR's manifest, else conventional commits), adds a `CHANGELOG.md` entry when the repo keeps one, and saves the notes as a draft GitHub release. PR merged → annotated tag on the merge commit, push, publish the draft
- Semver pre-releases: `--pre` counts up (`-beta.0` → `-beta.1`), moves `alpha` → `beta` → `rc`, and a run without it promotes `1.0.0-rc.2` → `1.0.0`. Pre-releases never become Latest
- Defers to release automation (release-please, changesets, semantic-release, goreleaser, tag-triggered workflows): pushes the tag only

### Changed

- `to-pr`: `Next:` points libraries at `/hb:to-release`
- `triage`: new state "PR merged, draft release waiting"; green PR → `/hb:to-release` for a library
- `guide`, README, AGENTS.md: SHIP phase covers `to-release`; the release convention is now a pointer to it

Full change list in [#22](https://github.com/helderberto/agent-skills/pull/22).

## [4.6.0] - 2026-10-16

With a tracker set, specs and tickets lived twice: `.specs/` files plus issues that nothing updated. Now each repo has one home. Without setup, nothing changes: markdown in `.specs/`.

### Added

- `setup` takes an argument: `/hb:setup [local | github | jira <KEY>]`. Rerun to switch; new work follows the new choice, nothing migrates
- `skills/setup/issue-tracker-local.md`: the local default as a seed, beside GitHub and Jira

### Changed

- GitHub or Jira set → specs and tickets live only there. No `.specs/specs/` or `.specs/tickets/` files, no `**Issue**` lines
- Seeds are short plain-language rules: where things live, when a ticket is done, how it closes. GitHub uses native `gh` flags (`--parent`, `--blocked-by`, `--json subIssues,blockedBy`)
- `to-spec`, `to-tickets`, `build`, `to-pr`, `review`, `triage`: follow `.specs/issue-tracker.md`, else the local seed. No per-tracker branches in skills
- `build`: ticks boxes in the tracker and closes the ticket after its commit. GitHub on a feature branch leaves it for the PR
- `to-pr`: links open tickets referenced in the branch's commits (GitHub: `Closes #n`)
- `to-tickets`: defines how to split a spec into parts
- README: "Where specs and tickets live"

Repos set up on 4.5.0: rerun `/hb:setup` to refresh the seed.

Full change list in [#20](https://github.com/helderberto/agent-skills/pull/20).

## [4.5.0] - 2026-10-16

Flow skills only wrote local markdown, so issues for specs and tickets were created by hand. An optional one-time `setup` now picks a tracker, and `to-spec` / `to-tickets` publish to it. Without setup, nothing changes.

### Added

- `setup`: optional, once per repo. Picks GitHub (`gh` CLI), Jira (Atlassian MCP), or local markdown (the default). Writes `.specs/issue-tracker.md` and never edits committed files: when `.specs/` isn't ignored, it goes into `.git/info/exclude`

### Changed

- `to-spec`: with a tracker configured, publishes the spec as one issue and records `**Issue**: <ref>` in the spec
- `to-tickets`: with a tracker configured, publishes one issue per ticket as children of the spec issue, with native blocked-by links. The local tickets file stays the source for `/hb:build`, and a rerun skips tickets already published
- Both: "local only" in the arguments skips publishing for that run

Full change list in [#19](https://github.com/helderberto/agent-skills/pull/19).

## [4.4.0] - 2026-10-13

`revise` polish caught em dashes and a few filler words, but left AI-sounding prose ("leverage", recap sentences, "not X, it's Y") untouched as "clear as written". The polish pass now strips those, and full revise no longer asks who the reader is.

### Changed

- `revise`: new AI-tells pass between typos and clarity: "leverage"/"utilize" → "use", "delve into" → "look at"; cut "robust", "seamless", "powerful" when vague (kept when precise, like "robust estimator"); cut throat-clearing, "It's not X, it's Y" framing, closing recap sentences, and mid-sentence bold
- `revise`: step 1 asks only for the takeaway and assumes engineers reading a public post unless told otherwise
- `revise`: dash rule and its grep also cover spaced `–` and `--`; number ranges and code stay untouched

Full change list in [#18](https://github.com/helderberto/agent-skills/pull/18).

## [4.3.0] - 2026-10-12

No skill answered "should we do this at all?" `grill` interviews with one voice, `review` judges correctness, and `to-pr`'s Merge Danger is the author grading their own change. `/hb:debate` gets an independent go/no-go on a risky change, with its blast radius and benefit measured.

### Added

- `debate`: advocate, skeptic, and a neutral investigator argue a PR, branch, plan, or change in parallel, read-only subagents, then cross-examine once; one recommendation: go, go with mitigations, alternative, or no-go
- The investigator measures cost (every consumer, with failures marked loud or silent) and benefit (who hits the problem, how often), and checks the artifact's own claims
- A bundled change defaults its alternative to shipping the uncontroversial parts alone; `--quick` runs only the skeptic and the investigator
- For a PR, offers to post the synthesis as a PR comment

### Changed

- `review`: NEEDS DISCUSSION points to `/hb:debate` for a go/no-go
- `guide`, README, `AGENTS.md`, and `docs/skill-conventions.md` list `debate`

Full change list in [#17](https://github.com/helderberto/agent-skills/pull/17).

## [4.2.1] - 2026-10-12

The README mixed onboarding with content only contributors need, and showed seven install blocks before the skill list. It is now about half the length: long sections moved to `docs/`, and installs fit in one table.

### Changed

- README: the workflow walkthrough and the `.specs/` artifact convention move to `docs/workflow.md`; the README keeps the flow diagram and a link
- README: naming, invocation tiers, and effort hints move to `docs/skill-conventions.md`; the Structure tree moves to `CONTRIBUTING.md`
- Install: Claude Code first, then one table (agent, command, setup guide) for the other tools; agents without a native integration install via `npx skills add -a <agent>`
- `create-skill`: the tier-rule checklist item points to `docs/skill-conventions.md`

### Added

- `docs/workflow.md` and `docs/skill-conventions.md`

Full change list in [#15](https://github.com/helderberto/agent-skills/pull/15) and [#16](https://github.com/helderberto/agent-skills/pull/16).

## [4.2.0] - 2026-10-11

The [#13](https://github.com/helderberto/agent-skills/pull/13) review found `to-pr` contradicting itself on diagrams and the secret-scanner tests missing most mutants. Fixing those reworked `to-pr` so the model writes the whole PR body, gave `/hb:review` dedicated read-only auditors, and extended install to seven tools.

### Changed

- `to-pr`: fills the repo's PR template, or the new default (Summary with a visual, Before/After evidence, one-way or two-way door, blast radius), and never asks. A bare `--diagram` makes the visual a mermaid diagram typed by the change
- `review`: the trust-boundary lens runs `security-auditor`; the perf lens runs `perf-auditor`, also on UI-only diffs (source checks only)
- `harden`: injection and output encoding, password hashing, OAuth PKCE, redirects, SRI, and an AI/LLM section
- `perf-audit`: Core Web Vitals source checks; no LCP, INP, or CLS number without a measurement
- `test-auditor`: edge scenarios and a mutation probe in a scratch copy; `code-review` reports what it ran vs only read
- `parity-check` renamed `parity-auditor`; agents are named `*-auditor`

### Added

- Agents `security-auditor` and `perf-auditor`, each preloading its skill
- `to-pr --skip-ci`: marks the HEAD commit `[skip ci]` and skips the CI watch
- Install for Cursor (`.cursor/skills/`), Antigravity CLI, GitHub Copilot, and Codex, plus `npx skills add helderberto/agent-skills`; manifests `plugin.json`, `.plugin/plugin.json`, and `.agents/plugins/marketplace.json`, kept in sync by CI
- scan-secrets tests cover every pattern branch, near misses, and skips: 23 of 24 mutants killed

### Removed

- `to-pr --fast` (the gate always runs), `--draft`, and `--no-diagram`

Full change list in [#14](https://github.com/helderberto/agent-skills/pull/14).

## [4.1.0] - 2026-10-11

`/hb:to-pr` stopped to ask for effort before `gh pr create`, so the PR never opened. It now writes a concise body from the diff, the commits, and the conversation, ends it with a mermaid diagram, and opens the PR.

### Changed

- `to-pr`: no question round and no effort line; every PR body ends with a mermaid diagram of the change. `--diagram=<type>` forces the type, `--no-diagram` skips it
- AGENTS.md: no Claude Code hooks, safety checks run on demand; releases tag the merge commit, then `gh release create`

### Added

- `scan-secrets.test.sh`: one case per secret pattern plus the skips
- CI job `Test skill scripts` runs it and `floor-guard.test.sh`

Full change list in [#13](https://github.com/helderberto/agent-skills/pull/13).

## [4.0.0] - 2026-10-11

v3 had 40 skills, all in the `/` menu and 34 auto-invoked. The 9-step spine overlapped, and spine skills chained on their own and collided with built-in `/code-review` and `/review`. v4 is a hard break: v3 names have no aliases.

```text
v3  grill-me → spec → plan → build → test → review → ship → create-pull-request → retro
v4  triage → grill → to-spec → to-tickets → build → review → to-pr → retro
```

### Changed

- `ask` → `triage`, `grill-me` → `grill`, `spec` → `to-spec`, `plan` → `to-tickets`, `create-pull-request` → `to-pr`, `create-adr` → `to-adr`, `diagnose` → `debug`, `explain-code` → `zoom-out`, `fortify` → `refactor`, `triage-review` → `feedback`, `validate-code` → `check`. The README has the full v3 → v4 table

### Removed

- `ship` (→ `to-pr`), `test` (→ `build` validation + `review` lenses), `e2e` (→ `tdd` UI-tests reference), `visual-validate` (→ `visual-review --ui`)

### Added

- `guide`: which skill fits, from a map of the flow
- `triage` routes any input (idea, bug, ticket, `[#42](https://github.com/helderberto/agent-skills/pull/42)`, PR URL, stack trace) by class and size; with no args it reports where you are
- `build --all` fans tickets out to background implementer subagents in worktrees, frontier by frontier
- `to-pr --safe` runs `safe-repo` on the branch before the push; `/hb:safe-repo` is typed, and `--diff <base>` scans a branch's changes
- PR template in `.github/`, with a bundled fallback in `to-pr`

### Changed

- Invocation tiers: 13 typed-only, 12 both, 12 model-only. Flow commands are typed-only, never chain, and end on a filled-in `Next: /hb:<cmd>` line; the `/hb:` menu shows 25 entries
- `to-pr`: gate (check, ADR check), push, PR on the repo's template, CI watch with `debug` (max 2)
- Tickets live in `.specs/tickets/` (was `.specs/plans/`)
- `code-review` is the correctness lens used by `build` and `review`

### Fixed

- `safe-repo` default scan finds private keys
- `review` secret-scans the whole branch, not only uncommitted changes

Full change list in [#12](https://github.com/helderberto/agent-skills/pull/12).

## [3.1.0] - 2026-10-08

`revise` already called `prose-fix` for its polish pass, so routing split one job across two skills. `revise` now does both.

### Removed

- `prose-fix` (→ `revise`). Asks like "fix typos", "fix dashes", "clean up text" route to `revise`, which runs its polish step alone for them

### Changed

- `revise`: step 4 holds the formatting → typos → clarity rules; full revise for article drafts, polish only for any other markdown or text
- README: `test` row says check-only, `create-pull-request` row lists Evidence and Merge Danger, artifact section covers `.specs/research/` and `$TMPDIR` reports
- Author email in the plugin and marketplace manifests

Full change list in [#11](https://github.com/helderberto/agent-skills/pull/11).

## [3.0.0] - 2026-10-08

The spec → PR chain now holds end to end: `build` drives `tdd`, `test` verifies without rewriting files, `review` checks the diff against the spec, and every step names the next one. Target flow: `grill-me → spec → plan → build → test → review → ship → create-pull-request → retro`.

### Changed

- Removed agent: `learner` (→ `retro` skill, which suggests environment changes and applies only what you pick)

### Added

- `retro` (user-invoked): session retrospective. Navigation pointers, automated checks, coding standards, steering no-ops; mechanical mistakes become checks, judgment calls go to `CODING_STANDARDS.md`
- `ask` (user-invoked): router from a situation to the skill or flow that fits, plus the phase-boundary tree (continue, `/clear`, handoff, subagent, `/compact`)
- `wait-what` (user-invoked): re-pitch the last message with context, in Simplified Technical English and glossary terms
- `skills/review/scripts/floor-guard.sh`: flags diffs that lower the bar (new suppressions, skipped or deleted tests, removed assertions, loosened thresholds, stubs, empty `catch`). Run by `review` and by `ship`'s gate

### Changed

- `build`: calls `tdd` at the phase's seams, `validate-code` for feedback, `commit` scoped to the phase's files; per-phase change summary; `--all` runs every phase after one approval
- `spec`: interviews via `grill-me`, writes settled terms through `domain-modeling`; updates an existing spec in place
- `plan`: never overwrites an incomplete plan; unread `[skill:x]` / `[agent:x]` tags dropped; parallel lanes get one worktree each
- `test`: runs `validate-code --check` (new flag), so verification writes nothing but checkboxes
- `review`: Spec, Standards, and Quality-bar reviewers; Standards and Spec keep separate headings; briefs carry requirements, never conclusions
- `ship`: floor-guard in the pre-launch gate
- `create-pull-request`: Before/After evidence, merge danger (door, blast radius), smallest-visual summary; commits leftovers via `commit`
- `code-review`: fetches the PR (number, URL, or current branch); owns pasted diffs; reviews tests first, with a mutation spot-check
- `prototype`: logic branch is one shareable HTML file (free-play buttons, guided scenario tabs); prototypes are kept on a `prototype/<name>` branch instead of deleted
- `architecture-audit`: scopes to `git log` hot spots, rates candidates Strong / Worth exploring / Speculative, offers an ADR on a load-bearing rejection, `--html` report
- `research`: `context: fork`, so it runs in the background; pass the question as the argument
- `commit`: optional path list scopes the run
- `diagnose`, `tdd`, `grill-me`, `handoff`: smaller sharpenings; `diagnose`'s post-mortem moves to `retro`
- Cross-skill: calls say "Call the Skill tool with `x`" (no `../x` links); glossary is `GLOSSARY.md` (`CONTEXT.md` still read); `visual-review`, `perf-audit`, and `handoff` write to `$TMPDIR`; `safe-repo` resolves its script via `${CLAUDE_SKILL_DIR}`
- Plugin: default `agents/` scan, so `plugin details` counts agents again

Full change list in [#10](https://github.com/helderberto/agent-skills/pull/10).

## [2.0.1] - 2026-09-15

Description-only pass: 35 model-invoked skill descriptions trimmed so the always-on listing shrinks and nothing exceeds the ~350-char guideline. No body, agent, or behavior changes.

### Changed

- Descriptions total 11.1k → 9.8k chars (≈2.8k → 2.45k resident tokens); 8 skills were over 340 chars, now the longest is 338
- Cuts came from the "what it does" clause — mechanism lists the body already covers (`diagnose` step chain, `review` orchestration detail, `frontend-ui-engineering` state list) and filler ("Use when user asks to" → "Use when asked to")
- Every quoted trigger phrase and every `Don't use for` neighbor pointer kept, after v2.0.0's pass showed dropping them hurt routing

**Kept intact**

User-invoked one-liners: `ship`, `teach`, `create-pull-request`.

## [2.0.0] - 2026-09-14

Every skill and agent audited against one test: does this line change what a current model does by default? Lines that failed were deleted. Skills + agents markdown went from ~4.5k to ~3k lines; always-on context cost drops accordingly.

### Changed

- Removed skills: `lint` (→ `validate-code`), `code-simplify` (→ `fortify`, simplify bucket), `setup-pre-commit` (no replacement)
- Removed agents: `git-detective`, `frontend-architect`, `security-auditor` (→ `harden` owns security knowledge; `review` spawns `general-purpose`)

### Changed

- `fortify` absorbs simplify; "harden" trigger moved to `harden` (they collided)
- `e2e` framework-agnostic (was Cypress-only)
- `create-pull-request`: concise body by default; `--diagram[=flow|sequence|class|state]` appends a mermaid diagram of the change
- `validate-code`: check-only lint asks no longer auto-fix
- `architecture-audit` points at `codebase-design/DESIGN-IT-TWICE.md` instead of duplicating it
- 19 descriptions trimmed, `/name` triggers dropped; `tdd` gained an anti-trigger
- Rationalization/Verification tables, one-line Error Handling sections, AskUserQuestion boilerplate removed everywhere
- `create-skill`, `CONTRIBUTING`, `AGENTS.md`: corrected stale claims (`model:` is honored for skills; `allowed-tools` is a valid field)

**Kept intact**

`diagnose`, `plan`, `codebase-design`, `grill-me`, `triage-review`, `create-adr`, `prototype`, `handoff`, `teach`, `domain-modeling`, `research`, `perf-audit`, `safe-repo`.

Full audit trail in [#8](https://github.com/helderberto/agent-skills/pull/8).

## [1.4.1] - 2026-09-01

Fixes routing gaps found by auditing the skill catalog's disambiguation graph. Two skills had no negative-trigger clause at all; four more excluded non-skills ("not backend code") instead of naming the sibling skill to use instead — which tells Claude where *not* to go, but not where *to* go.

### Fixed

- **diagnose** — was fully isolated while colliding head-on with `tdd` on "fix this bug". Now routes to `/tdd` (test-first work) and `/code-review` (diff review).
- **codebase-design** — three skills pointed at it, it pointed nowhere. Now routes to `/architecture-audit` (codebase-wide) and `/frontend-ui-engineering` (UI).
- **lint** — the catalog's closest description pair (38% with `validate-code`). Now names `/validate-code` and `/setup-pre-commit`.
- **a11y-audit / i18n / perf-audit** — the frontend-audit trio now cross-reference each other.

No behavior changes inside any skill body; descriptions only.

**Full changelog**: https://github.com/helderberto/agent-skills/compare/v1.4.0...v1.4.1

## [1.4.0] - 2026-08-21

Ports the strongest techniques from [mattpocock/skills](https://github.com/mattpocock/skills) and [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) into six skills.

### Added

- **grill-me** — rewritten around the design-tree **frontier**: questions batched in numbered rounds (`❓`/`➡️` with a recommended answer each), facts looked up by subagents instead of asked, done only when nothing is silently assumed — and "whatever you think is best" doesn't count as confirmation.
- **code-review** — approval standard ("approve when it definitely improves code health"), a 12-smell Fowler baseline (`references/smells.md`), **Nit**/**FYI** severity labels, split-strategy guidance for oversized PRs, and dependency-upgrade review rules (one dep per change, review the lockfile diff).
- **tdd** — new *Discover the stack* step (never assume `npm test`), a hard seam gate ("no test is written at an unconfirmed seam"), and the tautological-test anti-pattern (expected values must come from an independent source of truth).
- **diagnose** — Redact section for secrets in shown output, Phase 1 now exits only on a **red-capable** command you've already run (deterministic, fast, agent-runnable), and error output is treated as untrusted data.
- **plan / build** — phases declare **blocking edges** so independent phases can be built in parallel; wide refactors sequence as **expand → migrate → contract**; "and" in a phase title means two phases.
- **teach** — adopted the upstream update: reusable lesson components in `./assets/`, fluency-vs-storage-strength framing, now **user-invoked**.

**Full changelog**: https://github.com/helderberto/agent-skills/compare/v1.3.1...v1.4.0

## [1.3.1] - 2026-08-14

Remove resolving-merge-conflicts skill; bump hb plugin to 1.3.1.

## [1.3.0] - 2026-07-22

### Changed

Subagents now ship **with the plugin**. The six agents the skills fan out to are bundled under `agents/` and declared in `plugin.json`:

- `security-auditor` — threat modeling, vulnerability assessment
- `test-auditor` — test effectiveness beyond coverage
- `frontend-architect` — component design, deep modules, structural health
- `parity-check` — audit code migrations for missing functionality
- `git-detective` — investigate git history and trace changes
- `learner` — capture insights into CLAUDE.md

Installing `hb` is now self-contained: the agents that `/hb:review` and `/hb:plan` reference come along with the skills — no separate setup. **Claude Code only**; other agents keep consuming `skills/`.

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v1.2.0...v1.3.0

## [1.2.0] - 2026-07-22

### Changed
- Collapse the `code-reviewer` and `debugger` subagents into their skill twins (`code-review`, `diagnose`) — single source of truth, per the skill-only model (Matt Pocock / obra superpowers). `code-review` now carries the full review criteria: axes, "Common Rationalizations", and a verification checklist.
- Repoint `plan` and `review` references from removed agent types (`code-reviewer`, `debugger`, `test-quality`, `ts-enforcer`) to available ones.

Distinct read-only lenses without a skill twin (`security-auditor`, `test-auditor`, `frontend-architect`, `git-detective`, `parity-check`) are kept as subagents.

## [1.1.0] - 2026-07-21

### Added

- **`visual-review`** — renders a GitHub PR diff as a self-contained, offline HTML page where each changed hunk is annotated with a design/simplification principle and a suggested `before → after` rewrite. Read-only; you comment on the PR yourself.
  - **Lens (12 principles):** simplification (memoization, speculative abstraction, mutation, nesting, naming, dead weight, duplication) + engineering (SRP, dependency inversion & seams, OCP/LSP/ISP, testability, coupling & cohesion).
  - Deliberately scoped to **design feedback** — bugs, security, and scope/claim mismatches stay with `code-review`.
  - Sibling of `code-review` (text) and `visual-validate` (browser UI). Invoke with `/hb:visual-review [pr-url-or-number]`; defaults to the current branch's PR.

Registered in README + AGENTS; plugin bumped to 1.1.0.

## [1.0.0] - 2026-07-17

First stable release. The workflow has settled into a coherent, six-phase SDLC spine that carries a feature from idea to production — each phase a dedicated skill that orchestrates the smaller toolbelt skills beneath it.

**The flow**

```
SPEC → PLAN → BUILD → TEST → REVIEW → SHIP
```

- **`spec`** — interview + codebase exploration → a structured spec in `.specs/specs/<slug>.md`.
- **`plan`** — turn the spec into phased, tracer-bullet vertical slices in `.specs/plans/<slug>.md`.
- **`build`** — implement one phase per invocation, with feedback loops, checkbox marking, and a commit offer.
- **`test`** — prove it works: validation (lint/types/tests) + changed-line coverage, then verify plan checkboxes against the codebase via a read-only subagent.
- **`review`** — *optional* QA pass: fan out parallel, read-only reviewers (scope-detected audits + independent agent lenses) into one severity-ranked verdict.
- **`ship`** — pre-launch gate (`validate-code` + `safe-repo`) then atomic commits + push. User-invoked only.

Type the spine in order or let each phase chain into the next. Every model-invoked skill also auto-routes by description; the outward-facing steps (`ship`, `create-pull-request`) stay gated behind explicit invocation.

**What's in v1**

- **41 skills** across the SDLC spine plus on-demand tools: TDD, diagnosis, code review, a11y/i18n/perf/deps/security audits, design & discovery (codebase-design, architecture-audit, domain-modeling), and session/meta/writing helpers.
- **Artifact convention** — workflow skills persist to `.specs/{specs,plans}/`, local-first.
- **Toolchain-agnostic gates** — validation/coverage detect the project's own tooling (Node, Python, Go, Rust); no hardcoded package manager.
- **Effort routing** — skills carry an `effort` hint (low/medium/high/xhigh) so reasoning depth matches task complexity for the turn the skill fires.
- **Pure Markdown, zero runtime deps** — installable as a Claude Code plugin or copied into OpenCode, Gemini CLI, or Cursor.

**Changes since v0.10.0**

A behavior-preserving simplification pass (~168 lines of redundancy removed):

- **Within-skill restatement removed** — deleted sections that re-derived what a skill's own workflow/gate/frontmatter already stated (`ship`, `source-driven`, `create-adr`, `harden`, `visual-validate`, `codebase-design`, `build`).
- **Reference-file dedup** — trimmed reference files that restated their parent SKILL (`e2e/selectors.md`, `i18n/patterns.md`, `architecture-audit/deep-modules.md`, `safe-repo/report-template.md`), keeping each file's unique contribution.

**Full changelog**: https://github.com/helderberto/agent-skills/compare/v0.10.0...v1.0.0

## [0.10.0] - 2026-07-17

Skill-collection cleanup pass (analyzed with skill-creator).

### Changed
- **Removed `brief`** — leftover from an older flow; its progress-counting overlapped `test`'s Progress section. Routing in `AGENTS.md` and `handoff`'s cross-ref repointed to `test`.
- **Removed `grilling`; folded its interview engine into `grill-me`** — the two were near-duplicate model-invocable skills competing for the same trigger.
- **`review` marked as an optional QA pass**, not a ship gate — `ship`'s pre-launch gate is `validate-code` + `safe-repo` only.
- **`build`**: renamed "PRD" → "spec" in the read-only rule to match the `spec` skill.
- **Normalized `effort` frontmatter** — added `effort: high` to `test` (verify phase spawns a read-only subagent; matches the rest of the spine); moved `effort:` before `description` in `domain-modeling`, `research`, `resolving-merge-conflicts`.

Skill count: 43 → 41.

**Full changelog**: https://github.com/helderberto/agent-skills/compare/v0.9.0...v0.10.0

## [0.9.0] - 2026-07-17

**Gates now adapt to the project's toolchain**

Following Matt Pocock's **detect-and-delegate** pattern — the quality gates detect the ecosystem (Node / Python / Go / Rust) and run the project's own tasks instead of hardcoding `npm`. The SDLC flow now works for **backend in any language**, not just Node/TS.

- **`validate-code`** — detects fmt/lint/typecheck/test commands from the manifest
- **`lint`** — detects the project's linter/formatter
- **`deps-audit`** — detects the package manager from its lockfile (npm/pnpm/yarn/pip/go/cargo)
- **`build`** — feedback loop detects checks across ecosystems

**Removed the standalone `coverage` skill**

Neither Matt nor Addy ship a coverage skill — coverage is a TDD byproduct / review concern. Dropped the skill **and its `parse-lcov.py`** (the last script in the repo). `test` now does a **changed-line** coverage check inline, delegating to the project's coverage command when one exists.

**Full changelog:** https://github.com/helderberto/agent-skills/compare/v0.8.0...v0.9.0

## [0.8.0] - 2026-07-17

**`commit` now makes atomic commits by concern**

- **`commit`** groups unstaged changes into atomic commits by concern by default (a single concern is just one commit).
- **Push removed from `commit`** — pushing belongs to the `/ship` cycle.
- **Removed the redundant `atomic-commits` skill**; `ship` now links `commit`'s grouping rules.
- README + AGENTS updated.

**Full changelog:** https://github.com/helderberto/agent-skills/compare/v0.7.0...v0.8.0

## [0.7.0] - 2026-07-17

**SDLC spine renamed to `spec` / `plan` / `build` / `test` / `review` / `ship`**

- **`prd` → `spec`** — align with community naming (Matt Pocock, addy).
- **`verify-plan` → `test`** — now a VERIFY orchestrator: `validate-code` + `coverage` + plan-checkbox verification. Works for frontend and backend.
- **New `code-simplify` skill** — behavior-preserving simplification (Chesterton's Fence, clarity over cleverness); cross-refs `codebase-design` / `fortify` / `architecture-audit`.
- **Artifacts moved** `.specs/prds/` → `.specs/specs/`.
- Docs (README, AGENTS, CONTRIBUTING, cursor/gemini/opencode setup) and plugin manifest aligned. Dropped stale `check` / `tracerkit` references.

**Full changelog:** https://github.com/helderberto/agent-skills/compare/v0.6.0...v0.7.0

## [0.6.0] - 2026-07-17

**Highlights**

- **New skill: `frontend-ui-engineering`** — front-loads UI construction decisions (component boundary & prop API, where state lives, the required loading/empty/error/disabled states, responsive behavior, accessibility by construction). The frontend counterpart to `codebase-design`; hands off to `tdd` / `visual-validate` / `review`.
- **`review` now fans out to parallel subagents** — each scope-detected audit runs in its own fresh-context subagent, then findings are consolidated with convergence flagging. `validate-pr` has been consolidated into `review`.
- **Removed `caveman`** (unused).

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.5.0...v0.6.0

## [0.5.0] - 2026-07-17

**Highlights**

Bug fixes surfaced by a full skill-eval hardening pass (each skill run under eval):

- **`safe-repo`** — `scan-secrets.sh` silently detected nothing (`set -euo pipefail` aborted on a `grep` no-match; `grep -P` is unsupported on BSD/macOS). Rewritten with process substitution + POSIX ERE.
- **`atomic-commits`** — an unconditional `git push` could land on `main`; added a branch guard.
- **`validate-code`** — silent `eslint --fix` mutations; now reports the files it auto-fixed.
- **`perf-audit`** — interactive `vite-bundle-visualizer` hung headless; switched to non-interactive analysis.

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.4.0...v0.5.0

## [0.4.0] - 2026-07-14

**Highlights**

- **New skill: `triage-review`** — triage existing PR review comments (Copilot + human): fetch unresolved threads, verify each against current code, classify Address / Skip / Optional / Discuss. Read-only; offers to hand Address items to `/tdd`.
**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.3.0...v0.4.0

## [0.3.0] - 2026-07-14

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v2.0.10...v0.3.0

## [0.2.10] - 2026-06-30

### Changed
* feat: add validate-pr skill by @helderberto in https://github.com/helderberto/agent-skills/pull/5


**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.9...v0.2.10

## [0.2.9] - 2026-06-29

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.8...v0.2.9

## [0.2.8] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.7...v0.2.8

## [0.2.7] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.6...v0.2.7

## [0.2.6] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.5...v0.2.6

## [0.2.5] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.4...v0.2.5

## [0.2.4] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.3...v0.2.4

## [0.2.3] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.2...v0.2.3

## [0.2.2] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.1...v0.2.2

## [0.2.1] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.2.0...v0.2.1

## [0.2.0] - 2026-06-25

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.9...v0.2.0

## [0.1.9] - 2026-06-08

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.6...v0.1.9

## [0.1.6] - 2026-06-08

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.5...v0.1.6

## [0.1.5] - 2026-06-08

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.4...v0.1.5

## [0.1.4] - 2026-06-08

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.3...v0.1.4

## [0.1.3] - 2026-05-14

**Full Changelog**: https://github.com/helderberto/agent-skills/compare/v0.1.2...v0.1.3

## [0.1.2] - 2026-05-11

### Changed
* Release v0.1.0 — initial plugin release by @helderberto in https://github.com/helderberto/agent-skills/pull/1
* feat(testing): add test runner skill (v0.1.1) by @helderberto in https://github.com/helderberto/agent-skills/pull/2
* docs: add skill anatomy reference by @helderberto in https://github.com/helderberto/agent-skills/pull/3

**New Contributors**
* @helderberto made their first contribution in https://github.com/helderberto/agent-skills/pull/1

**Full Changelog**: https://github.com/helderberto/agent-skills/commits/v0.1.2

## [0.1.0] - 2026-05-11

**Full Changelog**: https://github.com/helderberto/agent-skills/commits/v0.1.0

[Unreleased]: https://github.com/helderberto/agent-skills/compare/v4.19.0...HEAD
[4.19.0]: https://github.com/helderberto/agent-skills/compare/v4.18.0...v4.19.0
[4.18.0]: https://github.com/helderberto/agent-skills/compare/v4.17.0...v4.18.0
[4.17.0]: https://github.com/helderberto/agent-skills/compare/v4.16.0...v4.17.0
[4.16.0]: https://github.com/helderberto/agent-skills/compare/v4.15.0...v4.16.0
[4.15.0]: https://github.com/helderberto/agent-skills/compare/v4.14.0...v4.15.0
[4.14.0]: https://github.com/helderberto/agent-skills/compare/v4.13.0...v4.14.0
[4.13.0]: https://github.com/helderberto/agent-skills/compare/v4.12.0...v4.13.0
[4.12.0]: https://github.com/helderberto/agent-skills/compare/v4.11.0...v4.12.0
[4.11.0]: https://github.com/helderberto/agent-skills/compare/v4.10.0...v4.11.0
[4.10.0]: https://github.com/helderberto/agent-skills/compare/v4.9.2...v4.10.0
[4.9.2]: https://github.com/helderberto/agent-skills/compare/v4.9.1...v4.9.2
[4.9.1]: https://github.com/helderberto/agent-skills/compare/v4.9.0...v4.9.1
[4.9.0]: https://github.com/helderberto/agent-skills/compare/v4.8.1...v4.9.0
[4.8.1]: https://github.com/helderberto/agent-skills/compare/v4.8.0...v4.8.1
[4.8.0]: https://github.com/helderberto/agent-skills/compare/v4.7.0...v4.8.0
[4.7.0]: https://github.com/helderberto/agent-skills/compare/v4.6.0...v4.7.0
[4.6.0]: https://github.com/helderberto/agent-skills/compare/v4.5.0...v4.6.0
[4.5.0]: https://github.com/helderberto/agent-skills/compare/v4.4.0...v4.5.0
[4.4.0]: https://github.com/helderberto/agent-skills/compare/v4.3.0...v4.4.0
[4.3.0]: https://github.com/helderberto/agent-skills/compare/v4.2.1...v4.3.0
[4.2.1]: https://github.com/helderberto/agent-skills/compare/v4.2.0...v4.2.1
[4.2.0]: https://github.com/helderberto/agent-skills/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/helderberto/agent-skills/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/helderberto/agent-skills/compare/v3.1.0...v4.0.0
[3.1.0]: https://github.com/helderberto/agent-skills/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/helderberto/agent-skills/compare/v2.0.1...v3.0.0
[2.0.1]: https://github.com/helderberto/agent-skills/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/helderberto/agent-skills/compare/v1.4.1...v2.0.0
[1.4.1]: https://github.com/helderberto/agent-skills/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/helderberto/agent-skills/compare/v1.3.1...v1.4.0
[1.3.1]: https://github.com/helderberto/agent-skills/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/helderberto/agent-skills/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/helderberto/agent-skills/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/helderberto/agent-skills/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/helderberto/agent-skills/compare/v0.10.0...v1.0.0
[0.10.0]: https://github.com/helderberto/agent-skills/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/helderberto/agent-skills/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/helderberto/agent-skills/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/helderberto/agent-skills/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/helderberto/agent-skills/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/helderberto/agent-skills/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/helderberto/agent-skills/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/helderberto/agent-skills/compare/v0.2.10...v0.3.0
[0.2.10]: https://github.com/helderberto/agent-skills/compare/v0.2.9...v0.2.10
[0.2.9]: https://github.com/helderberto/agent-skills/compare/v0.2.8...v0.2.9
[0.2.8]: https://github.com/helderberto/agent-skills/compare/v0.2.7...v0.2.8
[0.2.7]: https://github.com/helderberto/agent-skills/compare/v0.2.6...v0.2.7
[0.2.6]: https://github.com/helderberto/agent-skills/compare/v0.2.5...v0.2.6
[0.2.5]: https://github.com/helderberto/agent-skills/compare/v0.2.4...v0.2.5
[0.2.4]: https://github.com/helderberto/agent-skills/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/helderberto/agent-skills/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/helderberto/agent-skills/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/helderberto/agent-skills/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/helderberto/agent-skills/compare/v0.1.9...v0.2.0
[0.1.9]: https://github.com/helderberto/agent-skills/compare/v0.1.6...v0.1.9
[0.1.6]: https://github.com/helderberto/agent-skills/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/helderberto/agent-skills/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/helderberto/agent-skills/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/helderberto/agent-skills/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/helderberto/agent-skills/compare/v0.1.0...v0.1.2
[0.1.0]: https://github.com/helderberto/agent-skills/releases/tag/v0.1.0
