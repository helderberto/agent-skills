---
name: draft
description: Write an article from a blank page, mining raw fragments by interview and then shaping them into a draft block by block.
disable-model-invocation: true
argument-hint: '<topic | notes.md> [article.md]'
---

# Draft

Topic, notes, and article path: $ARGUMENTS. A topic or empty → step 1, asking for the topic if empty. A `.md` of raw notes → it is the pile: step 2.

Two phases, kept apart. **Explore** widens what could be said and commits to nothing. **Exploit** commits to one path through the pile. Structure during explore narrows the piece before the good material has surfaced.

Files go in the working directory unless paths are given: the pile at `<slug>.notes.md`, the article at `<slug>.md`, `<slug>` a kebab-case name of ≤4 words from the topic. Re-read a file from disk before every write: the user edits between turns, and their edits win.

## 1. Explore: mine fragments

Interview relentlessly, one or two questions at a time: what happened, what surprised you, what people get wrong, the example you keep telling. Capture fragments from the first prompt on. Append each one to the pile as it surfaces and say so in passing ("added"), without asking.

A **fragment** is any text that might survive into the article: a sharp sentence, a claim with its reason, a vignette, a code snippet, an analogy, a half-thought. The author must be able to read it; a cold reader need not. The pile opens with `# <working title>`, then fragments separated by `---`, in order of arrival, with no headings.

Push for a **leading word**. When an idea keeps returning, coin one name for it (_tracer bullets_, _fog of war_). It becomes the spine of the article, and often its title.

The user can say "cut that one", "sharpen it", or "merge those two" at any point: edit that fragment in place.

Done when the user calls the pile enough, and it holds a candidate takeaway and a concrete example for it.

## 2. Pin reader and takeaway

Read the pile end to end. Then one question round:

- **Reader**: who reads it. Default: engineers reading a public post.
- **Takeaway**: the one thing they remember. Propose one from the pile.
- **Grounded**: the concepts the reader already knows walking in.

A concept the reader lacks must be **grounded** by an earlier block before a later block can lean on it. Grounding a named concept lands the idea and its term together. Too much assumed shuts readers out; too much grounded drowns the opening in definitions.

Done when the takeaway is one sentence and the grounded list is agreed.

## 3. Pick the opening

Draft 2–3 openings from the pile, each implying a different angle on the takeaway. The user picks one or merges them. Write only that opening to the article.

Done when the article file holds the chosen opening.

## 4. Grow block by block

Loop: given what is on the page, what does the reader need next? Propose the next block from the pile, naming what it grounds and its form:

- **Prose** carries an argument; a **list** carries parallel items.
- A **table** when the same fields repeat 3+ times.
- A **callout** only for an aside that would derail the argument inline.
- A **code block** for anything multi-line or runnable.

Append each block once agreed; never write ahead. Keep the running grounded list. A block that leans on an ungrounded concept needs a grounding block before it, or the concept moves to the reader's prerequisites.

Push back like an editor: "what breaks if we cut this?", "this block does two jobs: split it", "the opening promised X and we drifted to Y". Mine the pile as a quarry: split, merge, paraphrase, and leave the rest unused. The pile lacks something a block needs → name the gap and ask for it now, or cut the move.

Done when the user calls the article done and the closing block lands the takeaway.

## 5. Revise

Call the Skill tool with `revise` on the article for a full revise, giving it the reader and the takeaway. The pile stays as written.

Done when `revise` has reported.

Next: `/hb:commit` to commit the article.
