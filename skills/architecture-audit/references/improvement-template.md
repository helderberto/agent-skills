# Improvement Template

## Problem

- Which modules are shallow and tightly coupled
- What integration risk exists in the seams between them
- Why this makes the codebase harder to navigate and maintain

## Proposed Interface

- Interface signature (types, methods, params)
- Usage example showing how callers use it
- What complexity it hides internally

## Dependency Strategy

Which category applies and how dependencies are handled:

- **In-process**: merged directly
- **Local-substitutable**: tested with [specific stand-in]
- **Ports & adapters**: port definition, production adapter, test adapter
- **Mock**: mock boundary for external services

## Modules to Consolidate

Which files/modules merge into the deep module.

## Modules to Remove

Shallow wrappers, pass-throughs, and their tests that become waste.

## Testing Strategy

- **New boundary tests**: behaviors to verify at the new interface
- **Old tests to delete**: shallow module tests that become redundant
- **Test environment needs**: any local stand-ins or adapters required

## Migration Sequence

Ordered steps from current state to target. Each step keeps the codebase green.

## Risks

What could break, what callers need updating, what edge cases to watch.
