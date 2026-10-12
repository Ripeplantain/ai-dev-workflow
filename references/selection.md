# Classification and selection

How to decide what a repo is, and from that, which files to write. Read this before the plan in install mode, and in update mode when checking whether an artifact still earns its place.

## The necessity test

Ask before writing each file:

1. Is this necessary?
2. Does this information already exist in the repository?
3. Will an agent actually use it?
4. Is this the correct location?
5. Can the same result be achieved with fewer files?

If the information already exists in a maintained document, link to it from `PROJECT.md` instead of restating it. If two planned files would each be under about fifteen useful lines, merge them.

The sharper version of question 1: would an agent behave worse on this repo without this file? A file that only describes good practice in general fails the test, because the agent already knows it. A file that says "new endpoints follow `src/routes/orders.ts`" passes.

## Classification

Size and shape are separate judgements. Record both in the plan, each with one line of evidence.

### Size

| Size | Typical signals |
|---|---|
| small | One deployable or package, one language, a handful of top-level source directories, one or two contributors, little or no CI |
| medium | Production application or maintained library, tests and CI present, clear internal layering, several contributors |
| large | Many modules or workspaces, multiple deployables or languages, layered CI, architecture that takes more than a paragraph to explain |

File count alone is not a signal. Judge by how much an unfamiliar agent must learn before it can make a safe change. A 2,000-file repo that is one Next.js app is medium; a 300-file repo that is three services sharing a schema is large.

### Shape

Choose every label that applies: `web-app`, `api`, `monorepo`, `multi-service`, `monolith`, `modular-monolith`, `multi-language`, `library`, `cli`, `llm-feature`, `data-pipeline`, `infrastructure`.

A repo can be a medium, multi-language monorepo containing a library and two services. Do not flatten it into one label — each label pulls in different roles and rules.

Size controls how much you write. Shape controls which roles and rules appear.

## Artifact selection

Starting points, not quotas. Remove anything that fails the necessity test; add only with a concrete reason.

| Artifact | small | medium | large |
|---|---|---|---|
| `AGENTS.md` (root, create or merge) | yes | yes | yes |
| `CLAUDE.md` (`@AGENTS.md`) | yes | yes | yes |
| `.agent/PROJECT.md` | yes | yes | yes |
| `.agent/rules/checkpoints.md` | yes | yes | yes |
| `.agent/rules/repo-sanity.md` | yes | yes | yes |
| `.agent/rules/engineering.md` | no (role docs carry it) | yes | yes |
| `.agent/rules/testing.md` | only if tests exist | if tests exist | yes |
| `.agent/rules/security.md` | no | conditional | conditional |
| `.agent/rules/design-system.md` | no | if UI code | if UI code |
| `.agent/rules/architecture.md` | no | no | only as overflow from `engineering.md` |
| `.agent/rules/data-contract.md` | if `data_signals` | if `data_signals` | if `data_signals` |
| `.agent/rules/evals.md` | if `ai_signals` | if `ai_signals` | if `ai_signals` |
| `.agent/agents/*.md` | planner, implementer, tester, reviewer | same | add investigator |
| `.agent/workflows/feature.md`, `fix.md` | yes | yes | yes |
| `.agent/workflows/refactor.md` | no | conditional | conditional |
| `.agent/workflows/migration.md` | no | if migrations exist | if migrations exist |
| `.agent/workflows/release.md` | no | if a release train exists | if a release train exists |
| `.agent/workflows/data-change.md`, `prompt-change.md` | per `references/data-ai.md` | same | same |
| nested `apps/*/AGENTS.md` | no | no | only where commands differ |
| adapters (`.claude/agents/`, `.codex/agents/`) | yes | yes | yes |

A small repo lands at 8–12 files including adapters. If a small repo is heading past that, something is failing the necessity test.

### Conditions for individual artifacts

| Artifact | Write only when |
|---|---|
| `rules/testing.md` | The repo has tests or a stated testing expectation. Without either, the tester role's doc is enough |
| `rules/security.md` | The repo handles auth, secrets, user data, payments, network input, or infrastructure |
| `rules/design-system.md` | The repo has UI code |
| `rules/architecture.md` | Only when the architecture section of `engineering.md` would push that file past 80 lines. There is no separate template: move the section out and leave a pointer behind |
| `workflows/migration.md` | There is a database with migrations, or another recurring migration type (API versions, framework upgrades) |
| `workflows/refactor.md` | The codebase is large or old enough that structural change is a regular task |
| `workflows/release.md` | The repo has release branches, version tags, or a changelog discipline |
| investigator role | The repo is large or hard to navigate, so investigation is a distinct phase whose output would otherwise flood the main thread |
| tester role | There is a real test suite to run and extend |
| data-engineer role | `data_signals`. On a pure pipeline repo it replaces implementer rather than joining it |
| evaluator role | `ai_signals` — an LLM feature in the product, not just an LLM-authored commit history |

## Optional `.agent/skills/`

Default: do not write one. The roles, rules, and workflows already carry the procedure, and a generic procedure file fails the necessity test.

Write `.agent/skills/<name>.md` only when all three hold: the repo has a recurring specialist task, no installed role doc covers it, and the procedure is specific to this repo. The realistic case is `api-design.md` on a repo whose public API other teams consume. Draw the content from `references/specialists.md` and bind it to the repo's own tools and conventions.

## Size budget

Generated files are read on every task, so their size is a recurring cost.

- `PROJECT.md`: under 120 lines. It is the one file every task loads; make it the index to everything else.
- Any other generated file: under 80 lines.
- Each file should be loadable alone, when relevant: a rule for its topic, a workflow for its task type.
- State in `PROJECT.md` when each file should be read, so agents do not load all of them.
- Prefer a link to a paragraph, and an exact command to a description of a command.
- Cut anything an agent would do correctly without being told.
