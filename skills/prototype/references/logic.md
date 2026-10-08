# Logic Prototype

A single, self-contained HTML file — a **shareable demo** — that lets anyone drive a state model by clicking buttons. Use this when the question is about **business logic, state transitions, or data shape**: the kind of thing that looks reasonable on paper but only feels wrong once you push it through real cases.

One file with nothing to install means a non-developer (designer, PM, domain expert) can feel the model for themselves. So it speaks their language, not the code's.

## When this is the right shape

- "I'm not sure if this state machine handles the edge case where X then Y."
- "Does this data model actually let me represent the case where..."
- "I want to feel out what the API should look like before writing it."
- Anything where someone wants to **press buttons and watch state change**.

If the question is "what should this look like" — wrong branch. Use [ui.md](ui.md).

## Process

### 1. State the question

Before writing code, write down what state model and what question you're prototyping. One paragraph, in a visible intro at the top of the demo, not just a comment. A logic prototype that answers the wrong question is pure waste — make the question explicit so it can be checked later, whether the user is watching now or returning to it AFK.

### 2. Isolate the logic in a portable module

Put the actual logic — the bit that's answering the question — in one `<script>` block written as a small, pure module that could be lifted into the real codebase later. The page around it is throwaway; the module isn't.

The right shape depends on the question:

- **A pure reducer** — `(state, action) => state`. Good when actions are discrete events and state is a single value.
- **A state machine** — explicit states and transitions. Good when "which actions are even legal right now" is part of the question.
- **A small set of pure functions** over a plain data type. Good when there's no implicit current state — just transformations.
- **A class or module with a clear method surface** when the logic genuinely owns ongoing internal state.

Pick whichever shape best fits the question being asked, _not_ whichever is easiest to wire to a page. Keep it pure: no DOM, no `document`, no button handlers reaching inside. The page calls into it; nothing flows the other direction. Once the question's answered, the validated reducer / machine / function set lifts into the real module on its own.

### 3. Build the shareable HTML file

One file, plain HTML/CSS/JS: no framework, no bundler, no server, everything inline, so it opens by double-click and survives being emailed around.

Write it for a non-developer. Every label is in **domain language** (the project's `GLOSSARY.md` terms when it has one): buttons and state read like the business, not the reducer.

Top to bottom:

1. **Title and one-line explanation** — the question from step 1.
2. **Current state** — a readable panel of labelled fields, not a raw JSON dump, re-rendered after every click. Call out what just changed.
3. **Free-play buttons** — one per action, always available, so anyone can poke the model in any order.
4. **Guided walkthroughs** — one **scenario** per tab: a short plain-language description (the situation and what to watch for), then the ordered buttons to press. Each step is a real button that performs its action and moves to the next step. Starting a walkthrough resets to a known initial state, so the scenario runs the same way every time.

Pick scenarios that show the awkward cases: the happy path, a tricky edge case, an attempt at something that should be illegal.

Clean typography, generous spacing, one accent colour. No animations: nothing competes with the state and the buttons.

### 4. Hand it over

Give the user the file path, or open it for them. The interesting moments are when someone says "wait, that shouldn't be possible" or "huh, I assumed X would be different" — those are the bugs in the _idea_, which is the whole point. If they want new actions or a new scenario, add them. Prototypes evolve.

### 5. Capture the answer and the prototype

Once the prototype has answered its question, capture both as the [SKILL](../SKILL.md) describes. The validated reducer / machine / function set lifts into the real module; the HTML file rides along to the `prototype/<name>` branch, where, being one self-contained file, it stays trivially re-runnable.

## Anti-patterns

- **Don't add tests.** A prototype that needs tests is no longer a prototype.
- **Don't wire it to the real database.** Use in-memory state unless the question is specifically about persistence.
- **Don't generalise.** No "what if we wanted to support X later." The prototype answers one question.
- **Don't blur the logic and the page together.** If the pure module references the DOM, `document`, or button handlers, it's no longer liftable.
- **Don't reach for a framework, bundler, or server.** One file the recipient double-clicks; a dev server defeats "shareable".
