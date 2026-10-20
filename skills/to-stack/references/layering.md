# Layering

Who owns each changed line, how to size layers, and the traps a rebuild from the final tree hits.

## Owners for shared files

| Shared file | The line goes with |
|---|---|
| Manifest dependency | the first layer that imports it |
| Dev dependency | the first layer whose tests use it |
| Peers, `engines`, `exports` entry | the entry point or policy it serves |
| Entry barrel export | its implementation |
| Type or type field | its first user. Fields only later layers read, such as legacy options or vendor event fields, wait for them |
| Core module code path | the capability that runs it. Hooks that only deprecated aliases need, and filters for legacy inputs, go with those aliases |
| Build-time value | the layer that writes it. A runtime reader of a build define lands with the build plugin |
| README section, CHANGELOG bullet | the code it describes. A bullet covering two layers is written partly in the lower one and completed in the upper one |

## Tests

- A test case belongs to the highest layer among everything it touches: mocks, globals, imports and options.
- Add a stand-in case only for behavior that would otherwise go untested in its own layer. Keep it minimal, because the final version replaces it.
- A shared setup line, such as a console spy for a vendor's noisy lookup, lands with the vendor that needs it.

## Size

- Aim for under ~600 changed lines per layer, lockfiles excluded and tests included. Over that, split by sub-capability.
- Under ~100 lines, merge it with a neighbor, unless it carries its own risk. A package-wide manifest change, for example, is worth a reviewer's full attention on its own.

## Pitfalls

- **Stale base.** Fetch, then diff against the remote base.
- **The base took your version.** Merge the base in and bump before you split.
- **Repeated headings.** Older CHANGELOG releases also have `### Changed` or `### Notes`. Anchor each edit on text that appears only once.
- **Generated files.** `git add -A` picks up output that the base doesn't ignore yet. Stage explicit paths.
- **Commit on red.** A `;` between the check and the commit commits anyway. Use `&&`.
- **zsh arrays start at 1.** Loop over `layer:sha` pairs instead of parallel arrays.
- **Adjacent edits.** Two layers that edit neighboring lines conflict on restack. Resolve by keeping both sides' intent, then rerun step 7's check.
