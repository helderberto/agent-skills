# ASCII Diagram Types

## Flow / Control flow

```
Input → [Validate] → [Process] → [Save] → Output
                         ↓
                      [Error] → Return 400
```

## Call stack / Sequence

```
Client          API           DB
  |──request──→  |             |
  |              |──query────→ |
  |              |←──result─── |
  |←─response──  |             |
```

## Tree / Hierarchy

```
App
├── Header
│   └── Nav
├── Main
│   ├── Sidebar
│   └── Content
└── Footer
```

## State machine

```
[Idle] ──submit──→ [Loading] ──success──→ [Done]
                       │
                    error↓
                   [Failed] ──retry──→ [Loading]
```

## Data structure

```
User {
  id: string
  profile: Profile ──→ { name, avatar, bio }
  posts: Post[]    ──→ [{ id, title, body }]
}
```

## Before / After

```
Before:               After:
fn()                  fn()
  doA()                 doA()
  doB()                 doB()
  doC()     →           helpers()
  doD()                   doC()
  doE()                   doD()
                          doE()
```
