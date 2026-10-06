# Reference: Repository Discovery

How to learn what a repository is from evidence. The lists below are prompts, not an exhaustive catalogue: if the repository uses something not listed, the same method applies.

## Method

1. Go from cheap and broad to expensive and narrow: root listing, then manifests and configuration, then CI, then documentation, then a sample of source.
2. Record each fact with the file it came from.
3. Prefer what is executed over what is described. CI configuration and manifest scripts outrank a README that may be stale.
4. When sources disagree, check which is current (`git log` on the files), and note the disagreement. If that does not settle it and the answer changes what gets written, it becomes a question for the user.
5. Mark anything you could not confirm as unknown. Do not fill the gap with what is typical for the stack.
6. Skip dimensions that do not apply. A CLI tool has no design system.

Do not read vendored code, build output, lockfile bodies, or generated files. Do not open secret files; note that they exist.

## Existing instructions (read first)

| Look for | Examples |
|---|---|
| Agent instruction files | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.cursorrules`, `.cursor/rules/`, `.windsurfrules`, `.claude/`, nested copies in subdirectories |
| Existing workflow directories | `.agent/`, legacy `.ai/`, and any other directory holding project context, rules, agent roles, or task workflows for AI agents (`.agents/`, `docs/ai/`). Open it and judge by content: `.agents/skills/` alone is an installed-skills directory, not a workflow |
| Contributor documentation | `README.md`, `CONTRIBUTING.md`, `docs/`, `ARCHITECTURE.md`, ADR directories, runbooks, PR and issue templates |

## Stack and tooling

| Dimension | Evidence |
|---|---|
| Languages | Manifests (`package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`, `*.csproj`, `composer.json`, `Gemfile`, `mix.exs`, `pubspec.yaml`, `Package.swift`), file extensions by volume, version files (`.nvmrc`, `.python-version`, `.tool-versions`) |
| Frameworks | Dependencies in manifests, framework configuration files, entry points |
| Package manager | Lockfile type, `packageManager` field, CI install step |
| Build | Manifest scripts, `Makefile`, `justfile`, `Taskfile`, bundler or compiler configuration, `Dockerfile` |
| Tests | Test runner configuration, test directories and naming, CI test step, coverage configuration |
| Lint, format, types | Linter and formatter configuration, type-checker configuration, pre-commit hooks, editor config |
| CI/CD | `.github/workflows/`, `.gitlab-ci.yml`, other pipeline files: the jobs that gate a merge are the project's real definition of "passing" |
| Deployment | Platform configuration, `Dockerfile`, compose files, infrastructure-as-code directories, release scripts |

**Commands.** For build, test, lint, format, type check, and run, record the exact command the project uses. Take them from manifest scripts and CI, in that order of convenience, and prefer the form CI runs. Note how to run a single test or a single package.

## Structure

| Dimension | Evidence |
|---|---|
| Topology | Workspace files (`pnpm-workspace.yaml`, `workspaces` field, `turbo.json`, `nx.json`, `go.work`, Cargo workspace, Gradle or Maven modules), multiple manifests, `apps/`, `packages/`, `services/`, multiple deployables in CI or compose |
| Architecture | Top-level source layout, how one representative request or command flows through the code, import direction between directories, module boundary rules in lint configuration |
| Important directories | Where features live, where shared code lives, where tests live, what is generated and must not be edited |

Trace one representative flow end to end. It reveals more about the real architecture than any directory listing.

## Data and interfaces

| Dimension | Evidence |
|---|---|
| Database | Dependencies, connection configuration names, compose services, schema files |
| Data access | ORM or query-builder usage, repository or DAO layers, raw SQL locations, migration directory and tool |
| API | Route definitions, OpenAPI or GraphQL schemas, protobuf files, versioning scheme, error response shape, client generation |
| Auth | Middleware, guards, session or token handling, permission checks, identity provider configuration |

## UI (only if UI code exists)

Component directories, styling approach, theme and token files, shared UI packages, component library dependencies, Storybook or similar, icon sets. Details in `references/design-tokens.md`.

## Git conventions

Recent `git log` (message format, scope of commits), branch names, commit lint configuration, PR template, CODEOWNERS, default branch, hooks.

For branch naming, record whether the convention is stated (contributor docs, agent instruction files, a branch-name hook or lint rule, CI branch filters) or only observed (`git branch -a`, merge commit subjects). A stated convention is a fact. An observed one is a candidate to confirm with the user. Note the pattern separately for each kind of work you can see (features, bug fixes, hotfixes, releases); they often differ.

## Output of discovery

A working set of facts, each with its source, covering only the dimensions that apply:

- Purpose of the project, in one or two sentences
- Classification inputs: size signals and topology signals
- Stack, tooling, and exact commands
- Architecture in the project's own terms, with the key directories
- Data, API, and auth patterns that exist
- UI and design-system facts, if any
- Git conventions
- Existing instructions and documentation, and what they already cover
- Unknowns and conflicts

This working set feeds classification and `PROJECT.md`. It is not written to the repository as a file of its own.
