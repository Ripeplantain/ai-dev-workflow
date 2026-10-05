# Changelog

All notable changes to this skill are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- A question step in install and update. After discovery and before writing, the agent asks the user, in one batch, about what the repository cannot settle: conflicting evidence, conventions the history does not establish, unrecorded facts, and intent. Non-interactive runs fall back to reported assumptions.

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
