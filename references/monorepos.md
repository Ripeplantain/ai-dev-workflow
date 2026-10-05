# Reference: Monorepos and Multi-Service Repositories

Load only when discovery finds workspaces, multiple packages, or multiple deployables.

## Establish the workspace model

| Question | Evidence |
|---|---|
| What defines the workspaces? | `pnpm-workspace.yaml`, `workspaces` in `package.json`, `nx.json`, `turbo.json`, `go.work`, Cargo `[workspace]`, Gradle `settings.gradle`, Maven modules, Bazel files, or simply several independent manifests |
| What are the units? | Apps (deployable), services (deployable, usually networked), packages or libraries (consumed by other units), tooling and configuration packages |
| What is shared? | Shared UI, database or schema packages, generated API clients, common types, configuration presets |
| Which way do dependencies point? | Internal dependencies in manifests, project graph (`nx graph`, `turbo` pipeline, `go.work`), boundary lint rules |
| How are tasks run? | Root scripts, task-runner pipelines, filters (`pnpm --filter`, `turbo run --filter`, `nx run`, `nx affected`, `go test ./path/...`, `cargo -p`) |
| How does CI decide what to run? | Path filters, affected-project detection, per-workspace jobs |
| How are units versioned and released? | Changesets, release tooling, independent versus locked versions, per-service deploy jobs |

## What agents need to know

Write these into `.agent/context/workspaces.md` (source: `templates/context/workspaces.md`), with a short summary in `PROJECT.md`:

- The units, one line each: path, kind, purpose.
- Allowed dependency direction, and anything that must never depend on something else.
- Where shared code belongs, so agents extend the shared package instead of duplicating into an app.
- Commands for one workspace and for affected workspaces. Running everything is rarely the right default in a large repository.
- What a change to a shared package requires: which consumers to build and test.
- Any workspace with a different language, toolchain, or deployment path.

## Scoped instructions

Default to one `.agent/` at the repository root. Add workspace-specific instructions only when a workspace genuinely needs different behavior:

- A different language or toolchain.
- A different architecture or testing approach.
- Regulatory or security constraints that apply to one unit.

When that is true, prefer a section in `.agent/context/workspaces.md`. Use a nested instruction file inside the workspace only when the difference is too large for a section, or the project already uses nested instruction files. Never generate a near-identical file per workspace.

## Task guidance to carry into generated workflows

- Identify the affected workspaces first, then their dependents.
- Make the change in the unit that owns the concern. Cross-workspace changes are at least L3 when they alter a shared interface (`references/task-complexity.md`).
- Verify the changed workspace and every dependent that could break, using the project's affected or filtered commands.
- Do not introduce a dependency that reverses the established direction or creates a cycle.
- Keep versions of shared dependencies aligned the way the repository already does.

## Multi-service repositories without a workspace tool

Treat each service directory as a unit with its own commands. Document how services communicate (HTTP, queues, shared database), where the contracts are defined, and how to run a service with its dependencies locally.
