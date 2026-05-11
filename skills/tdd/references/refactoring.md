# Refactor Candidates

After all tests are GREEN, look for:

- **Duplication** → Extract function/class
- **Long methods** → Break into private helpers (keep tests on public interface)
- **Shallow modules** → Combine or deepen (see [deep-modules.md](deep-modules.md))
- **Feature envy** → Move logic to where data lives
- **Primitive obsession** → Introduce value objects
- **Existing code** the new code reveals as problematic

Rules:
- Never refactor while RED — get to GREEN first
- Run tests after each refactor step
- If tests go RED after refactor, revert immediately and attempt smaller steps
