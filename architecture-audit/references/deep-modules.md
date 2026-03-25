# Deep Modules

A deep module has a **simple interface** hiding a **large implementation**. Depth = functionality / interface complexity. Maximize depth.

```
Deep:    [simple interface] ──────────────────── [large implementation]
Shallow: [large interface]  ── [small impl]
```

---

## Examples

**Deep — Unix file I/O**: five calls (`open`, `read`, `write`, `lseek`, `close`) hide buffering, caching, disk scheduling, permissions, and file locks. Callers never think about any of it. The interface is stable even as the implementation evolves.

**Shallow — layered wrappers**: requiring callers to compose `FileInputStream → InputStreamReader → BufferedReader` to read a file. Each class does almost nothing alone; the abstraction leaks the implementation. Callers must understand the layering to use it correctly.

---

## Anti-patterns

**Pass-through methods** — a method that only forwards to another with the same signature:

```typescript
class UserService {
  getUser(id: string) {
    return this.userRepository.getUser(id);
  }
}
```

Adds interface complexity with no abstraction benefit. Either merge the classes or give the wrapper a richer interface that justifies its existence.

**Temporal decomposition** — organizing modules around *when* things happen rather than *what* they represent:

```typescript
// Bad — caller must know the sequence
parseURL(raw)
readHeaders(stream)
readBody(stream)

// Better — sequence is hidden inside
parseRequest(stream): Request
```

**Classitis** — every small operation gets its own class. If callers always use three classes together in the same order, those three classes should be one.

---

## Key principles

**Information hiding** — hide design decisions likely to change. Test: *if the implementation changes, do callers need to change?* If yes, the detail was not hidden.

```
Good: save(key, value)          // storage engine is hidden
Bad:  insertRow / updateRow     // relational model leaks through
```

**Pull complexity downward** — when complexity must exist somewhere, put it in the implementation. Every caller that must handle your errors or understand your internals is paying your complexity tax.

**Define errors out of existence** — before adding an error case, ask whether the interface can be redesigned to make the error unreachable or trivially handled.

**Strategic over tactical** — invest slightly more upfront to get interfaces right. The payoff compounds — every future caller benefits from the cleaner abstraction.

---

## Signs a module is too shallow

- Interface documentation is longer than the implementation
- Callers always invoke it in the same sequence — that sequence belongs inside
- It's only called from one place — consider merging with the caller
- Its name describes *how* it works rather than *what* it provides (`bufferAndFlush` vs `write`)
- Changing the implementation requires changing callers
