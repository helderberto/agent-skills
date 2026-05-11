---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?" Don't use for modifying code, fixing bugs, or generating new implementations.
---

When explaining code, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?

Keep explanations conversational. For complex concepts, use multiple analogies.

## Diagram Types

**Flow / Control flow:**
```
Input -> [Validate] -> [Process] -> [Save] -> Output
                          |
                       [Error] -> Return 400
```

**Call stack / Sequence:**
```
Client          API           DB
  |--request-->  |             |
  |              |--query----> |
  |              |<--result--- |
  |<-response--  |             |
```

**Tree / Hierarchy:**
```
App
+-- Header
|   +-- Nav
+-- Main
|   +-- Sidebar
|   +-- Content
+-- Footer
```

**State machine:**
```
[Idle] --submit--> [Loading] --success--> [Done]
                       |
                    error|
                   [Failed] --retry--> [Loading]
```

**Data structure:**
```
User {
  id: string
  profile: Profile --> { name, avatar, bio }
  posts: Post[]    --> [{ id, title, body }]
}
```

**Before / After:**
```
Before:               After:
fn()                  fn()
  doA()                 doA()
  doB()                 doB()
  doC()     ->          helpers()
  doD()                   doC()
  doE()                   doD()
                          doE()
```

## Error Handling

- Code references external files/modules -- read them before explaining
- Diagram too complex -- split into multiple focused diagrams, each covering one concept
