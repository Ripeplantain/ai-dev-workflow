# Monorepos and multi-service repos

Load when the scan reports `workspaces`, several manifests, or multiple deployables.

## Establish the workspace model

| Question | Evidence |
|---|---|
| What defines the workspaces? | `pnpm-workspace.yaml`, `workspaces` in `package.json`, `nx.json`, `turbo.json`, `go.work`, Cargo `[workspace]`, or simply several independent manifests |
| What are the units? | Apps (deployable), services (deployable, networked), packages (consumed by other units), tooling/config packages |
| What is shared? | Shared UI, database or schema packages, generated API clients, common types, config presets |
| Which way do dependencies point? | Internal dependencies in manifests, project graph (`nx graph`, `turbo` pipeline), boundary lint rules |
| How are tasks run? | Root scripts and filters (`pnpm --filter`, `turbo run --filter`, `nx affected`, `go test ./path/...`, `cargo -p`) |
| How does CI decide what to run? | Path filters, affected-project detection, per-workspace jobs |
| How are units released? | Changesets, release tooling, independent versus locked versions, per-service deploy jobs |

## What goes where

Put the workspace model in `.agent/PROJECT.md` › Layout, not in a separate context file. One line per unit: path, kind, purpose. Then, in the same section:

- The allowed dependency direction, and anything that must never depend on something else.
- Where shared code belongs, so an agent extends the shared package instead of copying into an app.
- Commands for one workspace and for affected workspaces. Running everything is rarely the right default here, and `PROJECT.md` › Commands should give the filtered form first.
- What a change to a shared package requires: which consumers to build and test.
- Any workspace with a different language, toolchain, or deploy path.

If that pushes `PROJECT.md` past 120 lines, the overflow goes to `.agent/rules/architecture.md`, not to a new context file.

## Nested AGENTS.md

Default to one root `AGENTS.md` and one `.agent/`. Add `apps/<x>/AGENTS.md` only where a unit has commands or rules that genuinely differ — a different language or toolchain, a different testing approach, or constraints that apply to that unit alone. Nested files take precedence locally, so keep each one to the difference and point back to the root for everything else. Never generate a near-identical file per workspace.

## Carry into the generated workflows

- Identify the affected workspaces first, then their dependents.
- Make the change in the unit that owns the concern.
- Verify the changed workspace and every dependent that could break, using the repo's affected or filtered commands.
- Do not introduce a dependency that reverses the established direction or creates a cycle.
- Keep shared dependency versions aligned the way the repo already does.

## Multi-service without a workspace tool

Treat each service directory as a unit with its own commands. Record how services communicate (HTTP, queues, shared database), where the contracts live, and how to run one service with its dependencies locally.
