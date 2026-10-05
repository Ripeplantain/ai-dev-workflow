# Migration

Use for database, framework, runtime, dependency, API, or infrastructure migrations.

1. Discover current versions, data shape, consumers, deployment order, and rollback capability.
2. Classify compatibility, data-loss, security, and operational risk.
3. Plan staged transitions, invariants, backfill/dual-read/dual-write behavior when relevant, and rollback.
4. Implement the smallest safe stage; separate mechanical changes from behavior changes.
5. Verify with fixtures, representative data, compatibility tests, dry runs, and affected builds.
6. Review operational failure modes, observability, permissions, and cleanup of transitional code.
7. Report exact migration steps, ordering, verification evidence, and operator follow-up.

L3/L4 migrations should produce a decision record when the approach has meaningful long-term consequences.

