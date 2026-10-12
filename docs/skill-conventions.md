# Skill conventions

## Naming

- **Verb** — does work, asks you something or changes code: `triage`, `grill`, `build`, `review`, `retro`, `debug`, `refactor`.
- **`to-X`** — turns what's in context into artifact X, at most one question round, never an interview: `to-spec`, `to-tickets`, `to-pr`, `to-adr`.
- **`*-audit`** — read-only report: `a11y-audit`, `perf-audit`, `deps-audit`, `architecture-audit`.
- **`*-auditor`** — Claude Code agent: a read-only reviewer that skills fan out to, preloading the skill that holds its checklist when one exists: `test-auditor`, `security-auditor`, `perf-auditor`, `parity-auditor`.

## Invocation tiers

Rule: on the flow, outward-facing, expensive, or session control → **typed-only**. Reached only by other skills or plain phrasing → **model only**. Otherwise → **both**.

| Tier            | Frontmatter                      | Skills                                                                                                                                                                 |
| --------------- | -------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Typed-only (14) | `disable-model-invocation: true` | triage · grill · to-spec · to-tickets · build · review · to-pr · retro · architecture-audit · guide · handoff · wait-what · teach · debate                             |
| Both (12)       | default                          | debug · to-adr · zoom-out · commit · check · feedback · refactor · prototype · research · revise · create-skill · safe-repo                                            |
| Model only (12) | `user-invocable: false`          | tdd · code-review · codebase-design · domain-modeling · harden · source-driven · frontend-ui-engineering · visual-review · a11y-audit · i18n · perf-audit · deps-audit |

The `/hb:` menu shows typed-only and both (26 entries); the model sees both and model-only descriptions (24). Typed-only skills call model skills through the Skill tool and mention other typed-only skills only in `Next:` lines; the routers `triage` and `guide` name commands by design. Typed-only descriptions keep one what-it-does sentence; trigger phrases live only on model-visible skills.

## Effort

Skills also carry an **effort** hint: mechanical ones (`commit`, `to-adr`) run at low reasoning effort, heavy ones (`architecture-audit`, `harden`, `debug`) at high or xhigh, and the rest at the implicit medium default. The override lasts only for the turn the skill fires — so complexity matches the task without you touching `/effort`.
