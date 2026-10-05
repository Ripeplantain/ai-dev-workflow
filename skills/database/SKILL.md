# Database Change Skill

## Purpose

Make safe, repository-consistent schema, query, data, or migration changes.

## Use when

Changing schema, indexes, queries, ORM models, seed data, backfills, or data-access behavior.

## Do not use when

The change does not touch persistence or data contracts.

## Procedure

1. Discover the database, migration tool, transaction conventions, environments, and deployment order.
2. Identify data volume, existing constraints, consumers, locks, indexes, and rollback options.
3. Design for compatibility across old and new application versions when deployments are staggered.
4. Use parameterized queries and repository-approved access patterns.
5. Keep migrations deterministic, reviewable, and safe for representative data.
6. Separate schema changes, backfills, behavior changes, and cleanup when risk warrants.

## Verification

Validate migrations on a clean and representative database, run affected data-access tests, inspect query plans when relevant, and document rollback/operational steps.

## Expected output

Data model impact, migration order, safety/rollback plan, verification evidence, and operational follow-up.

