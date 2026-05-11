# Dependency Categories

When assessing a candidate for deepening, classify its dependencies. The category determines the testing strategy for the deepened module.

---

## 1. In-process

Pure computation, in-memory state, no I/O. Always deepenable — merge the modules and test directly. No substitutes or adapters needed.

## 2. Local-substitutable

Dependencies with local test stand-ins (e.g., PGLite for Postgres, in-memory filesystem, SQLite). Deepenable if the substitute exists. The deepened module is tested with the stand-in running inside the test suite.

## 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the module boundary. The deep module owns the logic; transport is injected.

- Production: real HTTP/gRPC/queue adapter
- Tests: in-memory adapter

Recommendation shape: *"Define a shared interface (port), implement an HTTP adapter for production and an in-memory adapter for tests, so the logic is testable as one deep module even though it deploys across a network boundary."*

## 4. True external (Mock)

Third-party services (Stripe, Twilio, OpenAI, etc.) you don't control. Mock at the boundary. The deepened module takes the external dependency as an injected port; tests provide a mock implementation.

---

## Testing Principle: Replace, Don't Layer

- Old unit tests on shallow modules become waste once boundary tests exist — delete them
- Write new tests at the deepened module's interface boundary
- Tests assert on observable outcomes through the public interface, not internal state
- Tests should survive internal refactors — they describe behavior, not implementation
