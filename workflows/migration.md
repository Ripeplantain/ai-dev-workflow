# Workflow: Migration

Moves the system from one state to another where the intermediate states matter: database schema or data changes, dependency or framework upgrades, API version changes, infrastructure moves. Always at least L3 (`references/task-complexity.md`).

For database work, use the database specialist skill (`specialist-skills/database/SKILL.md`).

## Discover

- Define the start state, the end state, and why now.
- Find how the project has done this kind of migration before: tooling, naming, previous migrations, runbooks.

## Understand

- List everything that reads or writes what is changing, including other services, jobs, reports, and clients you do not deploy.
- Establish data volume, downtime tolerance, and deployment order (can old code and new schema coexist?).

## Plan

A written plan, agreed before implementing:

- Steps in order, each one deployable and safe on its own.
- Compatibility window: expand, migrate, then contract, when old and new must coexist.
- Rollback for each step, and the point after which rollback is no longer possible.
- How success is verified, and what is monitored.

## Implement

- Work on a task branch and commit each unit once it is coherent and green (`specialist-skills/commit/SKILL.md`).
- Use the project's migration tooling and conventions. Never edit a migration that has already been applied elsewhere.
- Keep schema changes, data changes, and code changes in separate steps where the tooling allows.
- Make data changes idempotent and safe to re-run.

## Verify

- Run the migration forward on a realistic local or test dataset, and run the rollback.
- Run the application's tests against the migrated state.
- Never run against shared or production data without explicit instruction.

## Review

Independent review is required. The reviewer checks ordering, rollback, locking or downtime behavior, and data loss paths.

## Clean

Remove compatibility code and old structures only as the final planned step, not opportunistically.

## Report

What was migrated, verification performed, the rollback procedure, manual steps for operators, and anything deferred to a later contract step.
