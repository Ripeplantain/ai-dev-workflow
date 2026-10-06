# Rule: Project Installation

Governs what the installer may write into a target repository. Applies to Install and Update.

## Non-negotiables

- Setup requests are executed, not described.
- The project-side directory is `.agent/`. Never create `.ai/`. If the repository already keeps its AI workflow in another directory, that directory is the project-side directory: update it in place and never create `.agent/` beside it.
- Every statement written into `.agent/` is backed by evidence in the repository or by something the user said. No invented commands, paths, conventions, or architecture.
- Existing project instructions are preserved. Nothing in `.agent/` may contradict them.
- `.agent/` is self-contained: it must work for a teammate or agent that does not have this skill installed. Never link from `.agent/` to a path inside the skill.
- No generated file contains placeholders (`{{...}}`) or installer notes (`INSTALLER:`).
- Do not commit, push, install dependencies, or change project code as part of setup.

## The necessity test

Ask before writing each file:

1. Is this necessary?
2. Does this information already exist in the repository?
3. Will an AI agent actually use it?
4. Is this the correct location?
5. Can the same result be achieved with fewer files?

If the information already exists in a maintained document, link to it from `PROJECT.md` instead of restating it. If two planned files would each be under about fifteen useful lines, merge them.

## Classification

Complexity and topology are separate judgements. Record both, with evidence.

**Complexity**

| Level | Typical signals |
|---|---|
| small | One deployable or package, one language, a handful of top-level source directories, one or two contributors, little or no CI |
| standard | Production application or maintained library, tests and CI present, clear internal layering, several contributors |
| large | Many modules or workspaces, multiple deployables or languages, layered CI, architecture that takes more than a paragraph to explain |

File count alone is not a signal. Judge by how much an unfamiliar agent must learn before making a safe change.

**Topology** (choose every label that applies): single application, monolith, modular monolith, monorepo, multi-service, multi-language, library, CLI, infrastructure.

A repository can be, for example, a standard, multi-language monorepo containing a library and two services. Do not flatten it into one label.

## Artifact selection

Starting points, not quotas. Remove anything that fails the necessity test; add only with a concrete reason.

| Artifact | small | standard | large |
|---|---|---|---|
| `PROJECT.md` | yes | yes | yes |
| `WORKFLOW.md` (single file) | yes | no | no |
| `RULES.md` (single file) | usually | no | no |
| `rules/` directory | no | yes | yes |
| `workflows/` directory | no | yes | yes |
| `agents/` | no | planner, implementer, tester, reviewer | add investigator |
| `context/architecture.md` | no | only if `PROJECT.md` cannot hold it | usually |
| `context/workspaces.md` | no | only for workspaces | for workspaces or services |
| `context/design-system.md` | no | if a real design system exists | if a real design system exists |
| `skills/` | no | evidence-based | evidence-based |
| `decisions/` | no | no | only to record a real decision |

Every install has a task workflow: `WORKFLOW.md` for a small project, the `workflows/` directory otherwise. `WORKFLOW.md` is not skipped because `RULES.md` or the README covers the verification step; it carries what they do not (task sizing, the step sequence, the bug-fix procedure) and links to them for the rest.

A small project whose README and contributor docs already cover its conventions may need only `PROJECT.md` and `WORKFLOW.md`, without `RULES.md`.

### Conditions for individual artifacts

| Artifact | Generate only when |
|---|---|
| `rules/testing.md` | The project has tests or a stated testing expectation |
| `rules/security.md` | The project handles auth, secrets, user data, payments, network input, or infrastructure |
| `rules/design-system.md` | The project has UI code |
| `workflows/migration.md` | There is a database with migrations, or a recurring migration type |
| `workflows/refactor.md` | The codebase is large or old enough that structural change is a regular task |
| investigator agent | The repository is large or hard to navigate, so investigation is a distinct phase |
| tester agent | There is a real test suite to run and extend |
| `skills/database.md` | A database, ORM, or migration tool is present |
| `skills/api-design.md` | The project exposes an API that others consume |
| `skills/security-review.md` | Same condition as `rules/security.md`, at standard complexity or above |
| `skills/commit.md` | The repository is under Git, at standard complexity or above. Bind branch naming and message format to the project's own conventions where it has them, keeping a separate branch pattern for each kind of work the project distinguishes. Small projects get the same rules condensed into `RULES.md` |
| `skills/debugging.md`, `skills/testing.md`, `skills/refactoring.md` | Standard complexity or above, and the matching workflow was generated |

Specialist skills are copied from `specialist-skills/<name>/SKILL.md` into `.agent/skills/<name>.md`, trimmed and bound to the project's tools. Do not copy one the project has no evidence for.

Never generate technology-specific agents. Never create scoped, per-workspace instructions unless the workspaces genuinely need different behavior (see `references/monorepos.md`).

## Existing instructions

- Read every existing instruction source before writing. `references/repository-discovery.md` lists where to look.
- Existing files stay where they are and stay authoritative. Reference them from `PROJECT.md` under canonical documentation.
- Do not copy their content into `.agent/`. Capture only what they lack.
- If an existing instruction conflicts with what the code shows, do not silently pick one. Record the conflict in the completion report and, if it changes what you would generate, ask the user.

## The entry pointer

Agents only read `.agent/` if something tells them to. After writing `.agent/`:

- If the repository has an agent entry file (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.cursorrules`, `.cursor/rules/`, `.windsurfrules`), add a short section to each one that points to `.agent/PROJECT.md`. Add nothing else to those files.
- If none exists, create a minimal root `AGENTS.md` containing only that pointer.

This is the only change the installer makes outside `.agent/`.

## Asking the user

Proceed on evidence. Ask only when sources conflict or a fact is missing **and** the answer materially changes what gets generated (for example, two test runners with no indication of which is canonical). Ask once, with the candidates you found. Everything else goes into the report as an assumption.

## Size budget

Generated files are read by agents on every task, so they cost context each time.

- `PROJECT.md`: aim for under 120 lines.
- Any other file: aim for under 80 lines.
- Prefer a link to a paragraph, and a command to a description of a command.
