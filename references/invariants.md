# Project invariants

An invariant is a rule that, if broken, causes a security, data, or money bug that tests may not catch. The workflow should name the ones a repo already has and make the reviewer check them on every diff.

Only record an invariant you can point to in the repo: an existing rule in AGENTS.md or docs, a helper that every caller uses, or a test or CI job that enforces it. Quote its location in `PROJECT.md`. Do not invent invariants.

## What to look for

| Kind | Signals | Example rule to record |
|---|---|---|
| Tenancy | `tenant_id` columns, RLS policies, `withTenantContext`-style wrappers, `rls` tests or CI jobs | Tenant data is only queried inside the tenant context wrapper. |
| Auth guards | `requireAdmin`, `requireUser`, middleware lists, route guards | Admin handlers call the admin guard as their first line. |
| Money | amount fields, currency, ledger/transaction tables, decimal libs | Amounts are integers in minor units, or the project's decimal type; never floats. |
| Migrations | Drizzle/Prisma/Alembic dirs, `db:migrate`, `db:push` scripts | Schema changes go through generated migrations; push/migrate is a checkpoint. |
| Release train | `release/*`, `hot-fix/*` branches, version tags, changelog discipline | Feature work branches from the dev line; hotfixes from the release branch. Name the real patterns. |
| Quality gates | SonarQube/Sonar config, coverage thresholds, required CI checks | New code meets the gate; the reviewer runs or reads the gate's local equivalent. |
| Secrets | `.env.example`, encryption helpers, KMS usage | Tokens are stored encrypted with the existing helper; real env files are never read. |

## Where they go

- A short "Invariants" section in `.agent/PROJECT.md`: one line each, with the file or test that enforces it.
- The reviewer role doc's checklist references that section.
- If there is a cheap automatic check (a grep, an existing test), the tester role runs it.
