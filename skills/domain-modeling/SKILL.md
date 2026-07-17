---
name: domain-modeling
effort: high
description: Actively build and sharpen a project's domain model — challenge terms, pin down a ubiquitous language, and write the glossary and decisions down as they crystallize. Use when the user wants to define domain terminology, resolve ambiguous terms, or when another skill needs the shared vocabulary. Don't use for recording a single architectural decision (use /create-adr) or explaining existing code (use /explain-code).
---

# Domain Modeling

The *active* discipline of shaping the model — challenging terms, inventing edge-case scenarios, and writing vocabulary down the moment it crystallizes. Merely *reading* a glossary for vocabulary is a one-line habit any skill does; this skill is for when you're changing the model, not consuming it.

## Artifact

Maintain the project's glossary in its existing convention. If there is none, create `CONTEXT.md` at the repo root. Record decisions that settle a term via `/create-adr` so the *why* is preserved separately from the *what*.

## Ubiquitous language

One term, one meaning, used everywhere — prose, code, docs, and the glossary agree. For each term write:

- A crisp definition.
- An **Avoid** list of the rejected synonyms, so the same concept never travels under two names.

When the same word means two things, that ambiguity *is* the work — split it into two named terms and retire the overloaded one.

## Sharpen by stress

Invent edge-case scenarios that a term must survive. A definition that can't classify the edge case is still fuzzy — refine it until it can, then write it down immediately. Flag ambiguities you can't yet resolve; record the resolution once decided.

Completion: every term touched has a definition and an Avoid list, and every flagged ambiguity is either resolved or explicitly parked.
