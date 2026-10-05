<!-- INSTALLER: Source for .agent/workflows/migration.md. Generate only when the project has a database with migrations or another recurring migration type. Describe the project's actual tooling. Delete every INSTALLER note. -->

# Workflow: Migration

Always at least L3: written plan agreed first, independent review.

## This project's migration setup

- Tool: {{MIGRATION_TOOL}}
- Location and naming: `{{MIGRATIONS_DIRECTORY_AND_NAMING}}`
- Create: `{{CREATE_MIGRATION_COMMAND}}`
- Apply locally: `{{APPLY_COMMAND}}`
- Roll back: `{{ROLLBACK_COMMAND}}`
- How migrations reach deployed environments: {{DEPLOYMENT_MECHANISM_AND_ORDER_RELATIVE_TO_CODE}}

## 1. Understand

- Define the start state, end state, and reason.
- List everything that reads or writes what is changing: {{KNOWN_CONSUMERS_FOR_EXAMPLE_SERVICES_JOBS_REPORTS}}.
- Read the most recent comparable migration and follow its style.

## 2. Plan

- Ordered steps, each safe to deploy on its own.
- Whether old code must work with the new schema, and for how long (expand, migrate, contract).
- Rollback per step, and the point of no return.
- {{DOWNTIME_LOCKING_OR_DATA_VOLUME_CONSIDERATIONS}}

## 3. Implement

- Never edit a migration that has already been applied elsewhere; add a new one.
- Keep schema changes, data changes, and code changes in separate steps.
- Make data changes idempotent.
- {{GENERATED_ARTIFACTS_TO_REFRESH_FOR_EXAMPLE_SCHEMA_DUMP_OR_CLIENT_TYPES}}

## 4. Verify

- Apply forward and roll back locally.
- `{{VERIFICATION_COMMANDS}}` against the migrated state.
- Never run against shared or production data without explicit instruction.

## 5. Report

What was migrated, verification performed, rollback procedure, manual operator steps, and anything deferred to a later step.
