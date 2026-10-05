# Refactoring

Use when changing internal structure without intentionally changing behavior.

1. Discover current behavior, callers, contracts, tests, and architecture.
2. Define invariants that must remain true and confirm the change is necessary.
3. Plan small, reversible steps. Do not combine unrelated feature work.
4. Implement one cohesive structural change at a time.
5. Verify behavior with targeted tests and relevant type/lint/build checks.
6. Review for accidental API, performance, dependency, and boundary changes.
7. Clean and report the preserved behavior and evidence.

If the refactor exposes an architectural migration, stop and reclassify as L3/L4 rather than silently expanding scope.

