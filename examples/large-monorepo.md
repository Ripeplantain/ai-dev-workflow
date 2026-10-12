# Example: large monorepo

Shows the investigator role, nested `AGENTS.md`, a release train, and where the workspace model goes. The repo is hypothetical.

## The repo

`atlas`, a pnpm + Turborepo monorepo: two deployable apps, one service, three shared packages.

```text
atlas/
├── pnpm-workspace.yaml
├── turbo.json
├── package.json                 scripts delegate to turbo
├── apps/
│   ├── web/                     Next.js customer app
│   └── admin/                   Vite SPA, internal
├── services/
│   └── ingest/                  Go service, its own Dockerfile and Makefile
├── packages/
│   ├── db/                      Drizzle schema + migrations, source of truth
│   ├── ui/                      shared components, CSS custom properties
│   └── types/                   generated API clients
├── docs/adr/                    14 ADRs
└── .github/workflows/           ci.yml (affected-only), release.yml
```

## What the scan returned

```text
repo: atlas
file_count: 2140
git: yes  git_branch: develop  git_dirty_count: 0
git_branch_patterns: feature/(23) release/(6) hot-fix/(4) chore/(3)
lockfiles: pnpm-lock.yaml     lockfile_drift: no
package_manager_pinned: pnpm@9.12.0
workspaces: pnpm-workspace.yaml
npm_scripts: dev="turbo dev" | build="turbo build" | test="turbo test" |
  typecheck="turbo typecheck" | lint="biome check ." | db:generate=... | db:migrate=...
make_targets: build test run docker
stack: next vite react drizzle zod vitest playwright biome tailwind typescript go docker
ci: github-actions(ci.yml release.yml)
quality_gate: sonar
ai_signals: none
data_signals: none
agent_files: AGENTS.md          agent_dir: none
invariant_hints: withTenantContext(31) requireAdmin(9) tenant_id(44)
specs: docs/adr
```

An `AGENTS.md` already exists (41 lines of conventions someone wrote by hand). It is merged into, never overwritten.

## Classification

**Size:** large — three deployables, two languages, affected-only CI, a Sonar gate, a release train.
**Shape:** `monorepo`, `multi-service`, `multi-language`, `web-app`, `api`, `library`.

Read `references/monorepos.md` at this point, before planning.

## The plan shown

```text
agent-workflow v2.0.0 install plan: atlas
Classified: large · monorepo, multi-service, multi-language, web-app, api, library
Evidence: pnpm+turbo, Next/Vite/Go, Drizzle, vitest+playwright · tests: pnpm turbo test · CI: github-actions (affected) + sonar

Roles (5): planner [strong] · investigator [cheap] · implementer [default] · tester [default] · reviewer [strong]
Adapters: Claude Code (.claude/agents) · Codex (.codex/agents)

Will write:
  AGENTS.md                       merge into existing (41 lines kept)
  CLAUDE.md                       @AGENTS.md pointer
  .agent/PROJECT.md               stack, filtered commands, workspace model, invariants
  .agent/rules/checkpoints.md     incl. db:migrate, release tags, deploy, sonar gate
  .agent/rules/repo-sanity.md     shared-vs-app duplication is the live risk here
  .agent/rules/engineering.md     dependency direction + L0-L4 + release branches
  .agent/rules/architecture.md    overflow: workspace graph too long for engineering.md
  .agent/rules/testing.md         unit vs integration vs playwright, per workspace
  .agent/rules/security.md        tenancy, admin guards, service tokens
  .agent/rules/design-system.md   packages/ui is a real token layer
  .agent/agents/*.md              × 5
  .agent/workflows/feature.md
  .agent/workflows/fix.md
  .agent/workflows/migration.md   packages/db owns schema
  .agent/workflows/release.md     release/* + hot-fix/* train is real
  services/ingest/AGENTS.md       Go + Makefile, differs from every JS workspace
  .claude/agents/*.md             × 5
  .codex/agents/*.toml            × 5
Total: 25 files

Skipped: apps/web/AGENTS.md, apps/admin/AGENTS.md, packages/*/AGENTS.md (same
  toolchain and commands as root — a near-identical file per workspace is the
  thing references/monorepos.md says not to generate) · workflows/refactor.md
  (ADRs show structural change goes through a decision record, not a routine
  workflow) · rules/evals.md, rules/data-contract.md (no signals)
Enforced invariants:
  - Tenant data is only queried inside withTenantContext (packages/db/src/tenant.ts, 31 call sites)
  - Admin handlers call requireAdmin as their first line (9 call sites)
  - Schema changes originate in packages/db and go through drizzle-kit generate
  - Feature work branches from develop; hot-fix/* branches from the release branch
  - New code meets the Sonar gate (sonar-project.properties)
Found, not touching: existing AGENTS.md (41 lines, merged under it)

Approve? (yes / edit / no)
```

## Excerpts from the result

`.agent/PROJECT.md` › Commands — note the filtered forms come first, because running everything here takes 11 minutes:

```markdown
| Purpose | Command | Notes |
|---|---|---|
| install | `pnpm install` | checkpoint: changes pnpm-lock.yaml |
| dev, one app | `pnpm --filter @atlas/web dev` | |
| test, one workspace | `pnpm --filter @atlas/web test` | prefer this while working |
| test, affected | `pnpm turbo test --filter='...[origin/develop]'` | what CI runs |
| test, everything | `pnpm turbo test` | ~11 min; rarely the right default |
| typecheck | `pnpm turbo typecheck` | |
| ingest service | `cd services/ingest && make test` | Go, separate toolchain |
| db | `pnpm db:generate`, `pnpm db:migrate` | checkpoint: schema |
```

`.agent/PROJECT.md` › Layout — the workspace model lives here, one line per unit:

```markdown
| Path | Kind | Purpose |
|---|---|---|
| apps/web | deployable | Next.js customer app |
| apps/admin | deployable | Vite internal SPA |
| services/ingest | deployable | Go ingest service — see services/ingest/AGENTS.md |
| packages/db | library | Drizzle schema + migrations. Source of truth for schema |
| packages/ui | library | Shared components and CSS custom properties |
| packages/types | library | Generated API clients. Generated — do not hand-edit |

Dependencies point apps → packages. No package imports an app; packages/db
imports nothing from packages/ui. A change in packages/* requires building and
testing every consumer: `pnpm turbo test --filter='...@atlas/db'`.
```

`services/ingest/AGENTS.md`, the only nested file, kept to the difference:

```markdown
# services/ingest

Go service. The root AGENTS.md and `.agent/` apply, except:

- Commands are `make build`, `make test`, `make run` — not pnpm/turbo.
- Tests are Go table tests next to the source, not vitest.
- This service reads the same Postgres as packages/db but owns no migrations.
  Schema changes belong in packages/db.
```
