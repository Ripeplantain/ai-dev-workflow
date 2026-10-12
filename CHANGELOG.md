# Changelog

All notable changes to this skill are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.0] - 2026-10-12

A rewrite around one tool-neutral workflow plus thin adapters. The skill is now named `agent-workflow`; a user who installed it as `ai-engineering-workflow` has to re-link it.

### Added

- Three modes with their own workflow files: **install** (plan first, write on approval, `--yes` skips the wait), **update** (audit and targeted fixes, version stamp written last, v1→v2 migration), and **re-orient** (read-only; reports a dirty tree, stashes, and branch state so agents stop building on top of uncommitted work).
- `scripts/scan_repo.sh`: a read-only evidence scan printing `key: value` lines — stack, package manager, lockfile drift, scripts, CI, git state, existing agent files, data/AI signals, invariant hints, and hygiene problems. Every mode starts with it.
- Roles as neutral docs in `.agent/agents/<role>.md` with a `tier` (`strong`/`default`/`cheap`), plus generated adapters at `.claude/agents/<role>.md` and `.codex/agents/<role>.toml` that point at the role doc and carry only tool-specific wiring. Both formats checked against their official docs on 2026-10-12.
- Two new roles: `data-engineer` (pipelines, data contracts, validation tiers) and `evaluator` (eval sets, prompt version comparisons, cost per run).
- A data and AI layer (`references/data-ai.md`): data contracts with **halt** (identity/structural violations stop the run) and **quarantine** (value violations go to a quarantine output with a reason) tiers, eval sets with graders ordered cheapest first, prompt versioning, and a paid-call cost checkpoint.
- `.agent/rules/checkpoints.md` on every install: the hard stops, emitted rather than implied. The skill obeys the same ones while it runs.
- `references/selection.md`, carrying forward v1's necessity test and complexity/topology classification as size × shape, with an artifact table per size and per-artifact conditions.
- `references/questions.md`, carrying forward v1's batched question step and its branch-naming-per-kind-of-work rule.
- `references/invariants.md`: finding project-specific rules worth enforcing (tenancy wrappers, auth guards, money in minor units, migration discipline, release trains, quality gates) and recording them with the file that enforces them.
- `references/adapters.md` documents `disallowedTools` for read-only Claude Code roles, because an instruction in a rules file is not a permission boundary.
- Examples regenerated at three sizes: small CLI, medium app with an LLM feature, large monorepo.

### Changed

- `AGENTS.md` is canonical and `CLAUDE.md` contains only `@AGENTS.md`. Existing `AGENTS.md` content is merged into, never overwritten.
- Exact-case filenames are enforced; wrong-case `agents.md` is reported, and renaming needs approval and a two-step `git mv`.
- `scripts/validate.sh` replaces `scripts/validate-agent-dir.sh`, keeping its link checking, empty-file, placeholder, `INSTALLER:`, missing-path, and entry-pointer checks, and adding version-stamp, role-tier, adapter-mirroring, budget, and attribution-trailer checks. Still macOS bash 3.2 compatible, and still takes an optional workflow-directory argument.
- v1's seven rule files became templates under `templates/rules/`, written only when the repo gives them something to say. `checkpoints.md` and `repo-sanity.md` are written every time; `engineering.md` (which now carries architecture preservation, L0–L4 task sizing, and Git conventions) is written for medium and large repos.
- Budgets are explicit: 4–6 roles, `PROJECT.md` under 120 lines, other generated files under 80, whole install under ~25 files.

### Removed

- **Task mode.** The skill installs and maintains workflows; the generated `.agent/` runs the tasks. v1's seven task workflows are now templates, of which `feature`, `fix`, `refactor`, `migration`, and `release` survive as files a repo can earn.
- `code-review`, `investigation`, and `ui-feature` as generated workflows. Their content moved to the reviewer role doc, the investigator role doc, and `rules/design-system.md` respectively, because a second copy drifts from the first.
- `specialist-skills/` as generated output. The seven procedures are condensed into `references/specialists.md` and used as source material when filling role bodies and workflows. An optional `.agent/skills/<name>.md` is written only under the conditions in `references/selection.md`; update mode keeps any that a v1 install already wrote.
- `references/context-management.md`, `definition-of-done.md`, `design-tokens.md`, `repository-discovery.md`, and `task-complexity.md` as separate files. Their content moved into the install workflow's discovery method, `templates/workflows.md` ("Done means"), `templates/rules/design-system.md`, and `templates/rules/engineering.md`.

## [0.3.0] - 2026-10-06

### Added

- A question step in install and update. After discovery and before writing, the agent asks the user, in one batch, about what the repository cannot settle: conflicting evidence, conventions the history does not establish, unrecorded facts, and intent. Non-interactive runs fall back to reported assumptions.
- Branch naming is asked on every install, and on update when `.agent/` has no confirmed convention, unless the repository states it in a document, hook, or CI filter. Branch names observed in the history become the recommended option, not a settled fact. The question is asked per kind of work (features, bug fixes, and any others the team distinguishes), with the base branch for each, and the generated rules record one pattern per kind.
- A repository that already keeps an AI workflow in a directory under another name (such as `.agents/`) is updated in place instead of getting a second `.agent/` beside it. Directories holding only installed skills or tool settings are not treated as workflows. The validator takes the workflow directory name as an optional second argument.

### Changed

- Small projects always get `.agent/WORKFLOW.md`; only `RULES.md` remains optional. The validator reports an error when `.agent/` has neither `WORKFLOW.md` nor `workflows/`, and update mode adds a missing one.
- README install instructions cover any agent: a one-command install through the `skills` CLI, and a manual clone-once-and-link install with each agent's skills directory.

## [0.2.0] - 2026-10-05

Complete rewrite as a root-level installable skill.

### Added

- `SKILL.md` orchestrator with install, update, and task modes and a progressive loading table.
- Core invariant: a setup request is executed (inspect, generate, validate, review the diff, report), never answered with recommendations alone.
- `rules/project-installation.md`: the necessity test, complexity and topology classification, and per-artifact generation conditions.
- `workflows/install.md` and `workflows/update.md`, plus task workflows for feature, bugfix, refactor, investigation, migration, UI feature, and code review.
- References for repository discovery, task complexity (L0 to L4), context management, design tokens, monorepos, and definition of done.
- Templates for project context, single-file small-project rules and workflow, five agent roles, rules, workflows, and context files.
- Specialist skills: commit, debugging, testing, database, API design, refactoring, security review.
- Git flow for generated workflows: a `<type>/<short-slug>` branch per task, one commit per coherent unit, staging by path, no trailers or attribution, push and merge only on request. A project's own branch and message conventions take precedence.
- `scripts/validate-agent-dir.sh` to check a generated workflow.
- Worked examples for a small project, a standard project, and a monorepo.

### Changed

- The project-side directory is `.agent/` (previously `.ai/`). Update mode migrates a legacy `.ai/` workflow directory.
- Generation is adaptive. Templates are source material, and each artifact must be justified by repository evidence.
- Generated workflows are self-contained and do not depend on the skill being installed.

### Removed

- The nested `skills/custom-ai-workflow/` layout, the fixed question library, and the stack-specific scenario walkthroughs.

## [0.1.0] - 2026-10-05

Initial `custom-ai-workflow` skill.
