# Architecture Preservation

This standard does not prescribe a universal architecture.

## Rules

- Detect the current architecture from neighboring code, dependency direction, naming, and runtime boundaries.
- Follow established module boundaries and extension points.
- Reuse established patterns before introducing a new one.
- Do not turn a localized change into an architecture migration.
- Do not introduce competing layers such as use-cases, ports, gateways, or repositories unless the task explicitly requires the migration.
- Treat public APIs, shared packages, schemas, events, and persistence boundaries as compatibility surfaces.
- For L3/L4 changes, document boundary changes, dependency direction, rollout, and rollback considerations.

When an existing pattern is flawed but outside the request, mention it as a follow-up rather than silently broadening scope.

