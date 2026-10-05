---
name: database
description: Guides safe changes to database schema, data, and queries. Use when a task adds or alters tables, columns, indexes, or constraints, moves or backfills data, or changes queries with performance or integrity implications.
---

# Specialist Skill: Database

## Purpose

Change schema, data, and queries without losing data, breaking running code, or degrading performance.

## When to use

- Schema changes: tables, columns, indexes, constraints, types
- Data changes: backfills, transformations, deletions
- New or changed queries on large tables or hot paths
- Transaction, locking, or consistency questions

## When NOT to use

- Simple reads and writes through the existing data-access layer that follow an existing example
- Projects with no database

## Procedure

1. **Learn the setup.** Engine and version, migration tool, how migrations are named and applied, the data-access pattern, and how schema changes reach each environment relative to code deploys.
2. **Understand what exists.** Current schema, constraints, indexes, approximate data volume, and everything that reads or writes the affected tables.
3. **Design for compatibility.** If old code runs against the new schema at any moment, use expand, migrate, contract: add compatibly, move data and code, then remove.
4. **Assess operational impact.** Locks, table rewrites, index build time, and replication. On large tables use the engine's online options and batch data changes.
5. **Protect integrity.** Express invariants as constraints where the project does. Make data changes idempotent and bounded. Know exactly what a destructive step removes.
6. **Write the migration** with the project's tool and conventions. Include the rollback, or state clearly that it is irreversible. Never edit a migration already applied elsewhere.
7. **Write queries** through the project's data-access layer, parameterized. Check the plan for anything on a large table. Avoid query-per-row loops.
8. **Refresh generated artifacts** the project keeps in sync: schema dumps, generated types or clients.

## Verification

- Migration applies cleanly from the current schema, and rolls back if it is reversible.
- Application tests pass against the migrated schema.
- Data changes checked with before and after counts or spot checks on realistic data.
- Never run against shared or production data without explicit instruction.

## Expected output

The change, deployment order relative to code, locking or downtime expectations, rollback procedure and its limits, verification performed, and manual steps for operators.
