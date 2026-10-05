# Example: Standard Project

An illustrative install on a production web application with existing agent instructions. The repository is hypothetical.

## The repository

`bookings`, a Next.js application with a Postgres database.

```text
bookings/
├── CLAUDE.md                 12 lines: commands and "use pnpm"
├── CONTRIBUTING.md           branch and PR process, Conventional Commits
├── docs/architecture.md      maintained; describes the layering
├── package.json, pnpm-lock.yaml
├── prisma/                   schema.prisma, migrations/
├── src/
│   ├── app/                  routes and server actions
│   ├── server/               services/, repositories/, auth/
│   ├── components/ui/        shadcn-based shared components
│   └── styles/globals.css    CSS variables for theme tokens
├── tests/                    vitest unit tests; playwright e2e/
└── .github/workflows/ci.yml  lint, typecheck, test, build
```

## Evidence and classification

| Fact | Source |
|---|---|
| TypeScript, Next.js App Router, pnpm | `package.json`, lockfile |
| Route → service → repository → Prisma | `docs/architecture.md`, confirmed by tracing the create-booking flow |
| Prisma migrations | `prisma/migrations/` |
| Session auth enforced in `src/server/auth/` | middleware and service guards |
| Tokens are CSS variables consumed through Tailwind | `globals.css`, `tailwind.config.ts` |
| CI gates on lint, typecheck, unit tests, build | `ci.yml` |
| Existing instructions cover commands only | `CLAUDE.md` |

**Complexity:** standard. **Topology:** single application, monolith.

## Decisions

| Artifact | Decision | Reason |
|---|---|---|
| `PROJECT.md` | keep | Index, commands, and conventions; links to `docs/architecture.md` |
| `context/architecture.md` | skip | `docs/architecture.md` already exists and is current |
| `agents/` planner, implementer, tester, reviewer | keep | Production code with real tests and review |
| investigator agent | skip | Codebase is navigable; the architecture doc covers orientation |
| `rules/engineering.md`, `repo-sanity.md`, `testing.md`, `security.md` | keep | Each has project-specific content |
| `rules/design-system.md` | keep | UI code with tokens and shared components |
| `context/design-system.md` | skip | Four locations fit in the rule file |
| `workflows/feature.md`, `bugfix.md`, `migration.md` | keep | Regular task types; Prisma migrations have a specific procedure |
| `workflows/refactor.md` | skip | Young codebase; no evidence refactors are a regular task |
| `skills/commit.md` | keep | Git repository; bound to the Conventional Commits and branch rules in `CONTRIBUTING.md` |
| `skills/database.md`, `skills/security-review.md` | keep | Database and auth are present |
| Other specialist skills | skip | No server API consumed by others; debugging and testing guidance fit in the workflows |
| `CLAUDE.md` | append pointer | Existing content left untouched |

## Result

```text
bookings/
├── CLAUDE.md                 +4 lines (pointer section)
└── .agent/
    ├── PROJECT.md
    ├── agents/               planner.md, implementer.md, tester.md, reviewer.md
    ├── rules/                engineering.md, repo-sanity.md, testing.md, security.md, design-system.md
    ├── workflows/            feature.md, bugfix.md, migration.md
    └── skills/               commit.md, database.md, security-review.md
```

Excerpt from the generated `rules/engineering.md`, showing generic guidance replaced by local fact:

```markdown
## Preserve the architecture

Route handlers and server actions in `src/app/` call services in `src/server/services/`.
Services call repositories in `src/server/repositories/`. Only repositories import the
Prisma client. Details: `docs/architecture.md`.

- A new server action follows `src/app/bookings/actions.ts`.
- A new service follows `src/server/services/booking-service.ts`.
- Authorization happens in the service via `requireUser()` from `src/server/auth/`,
  never in the component.
```

The generated `skills/commit.md` keeps the branch-first, commit-per-unit procedure but takes its message format and branch names from `CONTRIBUTING.md`, which it links to instead of restating.
