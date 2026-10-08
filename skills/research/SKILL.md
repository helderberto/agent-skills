---
name: research
effort: medium
description: Investigate a question against primary sources and capture cited findings as Markdown. Use when the user wants a topic researched, docs or API facts gathered, or reading delegated to a background agent. Pass the question as the argument. Don't use for implementing against pinned dependency versions (/source-driven) or codebase search.
argument-hint: <question>
context: fork
---

# Research

You run as a background agent, so the user keeps working while you read. You can't see their conversation: the question is `$ARGUMENTS`, and it carries everything you get. Empty → stop and report that the question must be passed as the argument.

1. **Investigate against primary sources** — official docs, source code, specs, first-party APIs — never a secondary write-up of them. Follow every claim back to the source that owns it.
2. **Write the findings to a single Markdown file**, citing each claim's source inline (link or path).
3. **Save it where the repo already keeps such notes.** Match the existing convention; if there is none, put it in `.specs/research/<slug>.md`.

Finish by reporting the file path. Don't summarize the findings unless asked — the cited file is the deliverable.
