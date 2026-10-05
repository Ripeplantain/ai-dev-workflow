# Example: Monorepo

An illustrative install on a large, multi-language workspace. The repository is hypothetical.

## The repository

`fleet`, a logistics platform.

```text
fleet/
├── AGENTS.md                    short; describes the PR process
├── pnpm-workspace.yaml, turbo.json
├── apps/
│   ├── dashboard/               React + Vite web app
│   └── driver/                  React Native app
├── services/
│   ├── api/                     NestJS, Postgres via Drizzle
│   └── routing/                 Go service, own go.mod, gRPC
├── packages/
│   ├── ui/                      shared components and Tailwind preset
│   ├── db/                      Drizzle schema and migrations
│   ├── contracts/               protobuf definitions, generated clients
│   └── config/                  shared eslint and tsconfig
├── docs/adr/                    14 decision records
└── .github/workflows/           per-path CI, affected-only via turbo
```

## Evidence and classification

| Fact | Source |
|---|---|
| pnpm workspaces with Turborepo; CI runs affected tasks only | `pnpm-workspace.yaml`, `turbo.json`, workflows |
| `services/routing` is Go with its own toolchain and Makefile | `go.mod`, `Makefile`, its CI job |
| Apps and services depend on packages, never the reverse | manifests; `eslint-plugin-boundaries` configuration |
| Schema and migrations live only in `packages/db` | Drizzle configuration |
| Service contracts are protobuf with generated clients | `packages/contracts`, `buf.yaml` |
| Shared UI and tokens in `packages/ui`, used by both apps | imports, Tailwind preset |
| Decisions recorded as ADRs | `docs/adr/` |

**Complexity:** large. **Topology:** monorepo, multi-service, multi-language.

## Decisions

| Artifact | Decision | Reason |
|---|---|---|
| `PROJECT.md` | keep | Short index; root commands; pointers into context files |
| `context/architecture.md` | keep | No single architecture document exists; service interaction needs explaining |
| `context/workspaces.md` | keep | Units, dependency direction, filtered and affected commands |
| `context/design-system.md` | keep | A real shared system used by two apps |
| All five agents | keep | Large and unfamiliar enough that investigation is its own phase |
| `rules/` engineering, repo-sanity, testing, security, design-system | keep | Each has project-specific content |
| `workflows/` feature, bugfix, refactor, migration | keep | All are regular task types here |
| `skills/` commit, database, api-design, security-review, debugging, testing, refactoring | keep | Evidence for each: Git, Drizzle, protobuf contracts, auth in the API, matching workflows |
| `decisions/` | skip | `docs/adr/` already serves this purpose; linked from `PROJECT.md` |
| Per-workspace instruction files | skip | Only `services/routing` differs, and a section in `workspaces.md` covers it |
| `AGENTS.md` | append pointer | Existing content left untouched |

## Result

```text
fleet/
├── AGENTS.md                    +4 lines (pointer section)
└── .agent/
    ├── PROJECT.md
    ├── agents/                  investigator, planner, implementer, tester, reviewer
    ├── rules/                   engineering, repo-sanity, testing, security, design-system
    ├── workflows/               feature, bugfix, refactor, migration
    ├── context/                 architecture, workspaces, design-system
    └── skills/                  commit, database, api-design, security-review, debugging, testing, refactoring
```

Excerpt from the generated `context/workspaces.md`:

```markdown
## Commands

| Task | Command |
|---|---|
| One workspace | `pnpm turbo run test lint --filter=@fleet/api` |
| Affected by current changes | `pnpm turbo run test lint build --filter=...[origin/main]` |
| Everything | `pnpm turbo run test lint build` (slow; CI does not do this on PRs) |

## Changing a shared package

A change to `packages/contracts` requires `pnpm --filter @fleet/contracts generate`,
then building `services/api`, `apps/dashboard`, and `apps/driver`, and running
`make generate test` in `services/routing`. Treat it as L3.

## Workspace-specific notes

### services/routing

Go 1.23, not part of the pnpm workspace. Use `make test` and `make lint` from that
directory. Layout follows `cmd/` and `internal/`; do not apply the NestJS module
conventions from `services/api` here.
```

Even at this size the installer skipped two things: a `decisions/` directory that would duplicate `docs/adr/`, and per-workspace instruction files that would differ only trivially.
