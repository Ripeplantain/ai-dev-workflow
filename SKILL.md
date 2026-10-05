---
name: ai-engineering-workflow
description: Sets up or updates a tailored `.agent/` AI engineering workflow inside any software repository. Use when asked to install, initialize, configure, set up, update, refresh, or audit a project's AI workflow, agent instructions, or `.agent/` directory. Inspects the repository, classifies it, then creates or updates only the workflow files that repository actually needs.
metadata:
  version: 0.2.0
---

# Universal AI Engineering Workflow

This skill creates and maintains an AI engineering workflow in **other** repositories. The workflow lives in the target repository's `.agent/` directory and is tailored to how that repository really works.

> AI adapts to the repository. The repository does not adapt to the AI.

Paths in this file are relative to the skill's own directory. `.agent/` always means the directory in the target repository.

## Core invariant

When asked to install, initialize, configure, set up, or update a project's AI workflow, you **do the work**: inspect the repository, write the files, verify them, and report. Stopping at "I recommend creating a `.agent/` directory" is a failure. Recommend-only output is correct only when the user explicitly asks for a plan, a preview, or a dry run.

Doing the work includes asking. A short batch of questions before writing (see [Questions](#questions)) is part of the procedure, not a way of stopping short of it.

## Choose the mode

| Situation | Mode | Load |
|---|---|---|
| No `.agent/` in the target repository | Install | `workflows/install.md` |
| `.agent/` exists | Update | `workflows/update.md` |
| A legacy `.ai/` workflow directory exists and `.agent/` does not | Update (migrate first) | `workflows/update.md` |
| User wants an engineering task done, not a workflow set up | Task | See [Task mode](#task-mode) |

If the user says "set up" but `.agent/` already exists, run Update. Never overwrite an existing workflow wholesale.

## The procedure

Install and Update both follow this sequence. The workflow file for the mode gives the detail for each step.

1. **Inspect** the target repository: root listing, manifests, directory shape, Git state.
2. **Read existing instructions**: `AGENTS.md`, `CLAUDE.md`, editor and assistant rule files, `CONTRIBUTING.md`, architecture docs. These are authoritative and must be preserved.
3. **Discover** architecture and tooling from evidence, following `references/repository-discovery.md`. Do not guess; an unconfirmed fact is recorded as unknown or left out.
4. **Classify** the repository by complexity (small, standard, large) and topology (it may have several).
5. **Decide the artifacts** using `rules/project-installation.md`. Each file must pass the necessity test before it is written.
6. **Ask** the user, in one batch and before writing anything, what the repository could not settle (see [Questions](#questions)).
7. **Load only the templates and references** the decision calls for (see the table below).
8. **Customize**: replace every placeholder with repository evidence and the user's answers, delete sections with nothing to say, and use the project's real commands, paths, and names.
9. **Write or update `.agent/`**, and make sure the project's agent entry file points to it.
10. **Validate**: run `scripts/validate-agent-dir.sh <target-repo-root>` and execute the verification commands you documented, where it is safe to do so.
11. **Review the diff** (`git status`, `git diff`) and remove anything that is generic, duplicated, or unsupported by evidence.
12. **Report** what was created, changed, skipped, asked, and assumed.

## Questions

Discovery answers most things, and anything the repository answers is never asked. What is left goes to the user in step 6, because a wrong guess written into `.agent/` is repeated on every later task.

Ask when the answer changes what gets written and the repository cannot give it:

| Kind | Examples |
|---|---|
| Conflicting evidence | Two lockfiles from different package managers; a README command that CI or the manifest contradicts |
| A convention the repository does not establish | Branch and commit rules when the history shows no clear pattern, or when a template rule would be stricter than current practice |
| A fact nothing records | Deployment target, required environments, a command with no script (type check, single test) |
| Intent | Things agents must always or never do here that no file states; whether a borderline artifact is wanted |

How to ask:

- Finish discovery first, then ask once. Do not interleave questions with exploration, and do not ask again later for something you could have asked here.
- Keep it to the questions that matter, usually one to four. No fixed list: every question comes from something this repository left open.
- For each question, say what you found and offer concrete options with your recommended one first, so the user can answer in a word.
- Use the agent's structured question tool if it has one; otherwise ask in a plain message and wait.
- An answer is evidence. Write it into `.agent/` as fact and name it in the report.

Do not ask when the user said not to, or when nobody can answer (a non-interactive or scripted run). Then take the best-supported option, and list each such choice in the report as an assumption with the alternative. If discovery left nothing open, skip the step and say so in the report.

## Progressive context loading

Read only what the current step and this repository require. Never load the whole skill up front. `references/context-management.md` explains the budget.

| Load | When |
|---|---|
| `workflows/install.md` or `workflows/update.md` | Always, for the chosen mode |
| `rules/project-installation.md` | Always, before deciding artifacts |
| `references/repository-discovery.md` | Always, during discovery |
| `templates/project/PROJECT.md` | Always, when writing project context |
| `templates/project/RULES.md`, `templates/project/WORKFLOW.md` | Small projects only |
| `templates/agents/*`, `templates/rules/*`, `templates/workflows/*` | Only the specific files selected in step 5 |
| `references/monorepos.md`, `templates/context/workspaces.md` | Workspace or multi-service evidence found |
| `rules/design-system.md`, `references/design-tokens.md`, `templates/context/design-system.md`, `templates/rules/design-system.md` | UI code found |
| `templates/context/architecture.md` | Large projects, or architecture that `PROJECT.md` cannot summarize in a few lines |
| `specialist-skills/<name>/SKILL.md` | Only the specialists the project has evidence for (see `rules/project-installation.md`) |
| `references/task-complexity.md`, `references/definition-of-done.md` | When generating workflows, or in Task mode |
| `examples/*` | Only if unsure what a proportionate result looks like |

A repository with no UI never needs the design-system files. A repository with no database never needs the database specialist. A single-package repository never needs the monorepo reference.

## Templates are source material

Files under `templates/` are raw material, not a checklist of files to produce. A template is used only when the installer has decided that artifact is necessary. Sections of a used template are deleted when the repository gives them nothing to say. No generated file may contain a leftover placeholder or installer note.

## Vocabulary

Keep these four concepts separate, in this skill and in everything it generates.

| Concept | Answers | Example |
|---|---|---|
| Agent | Who is carrying a responsibility | planner, reviewer |
| Skill | What specialized procedure is needed | debugging, security review |
| Workflow | How a type of task progresses | feature, bugfix |
| Rule | What constraints always hold | repo sanity, testing |

Technology knowledge comes from project context and specialist skills. Never generate technology-named agents such as a React agent or a Python agent.

## Task mode

When the user wants engineering work done rather than a workflow installed:

1. If the target repository has `.agent/`, follow it. It is more specific than this skill.
2. Otherwise classify the task with `references/task-complexity.md` and follow the matching file in `workflows/` (`feature`, `bugfix`, `refactor`, `investigation`, `migration`, `ui-feature`, `code-review`), applying `rules/` and loading a specialist skill only when the task needs it. Branch before the first edit and commit each finished unit, following `specialist-skills/commit/SKILL.md`.

## Completion report

End every install or update with a short report:

- Mode, and the classification with the evidence behind it
- Files created, files changed, and existing files deliberately left alone
- Artifacts considered and skipped, with one reason each
- Verification commands recorded, and which ones you ran with their result
- Questions asked and the answers used, or that nothing needed asking
- Assumptions and anything the repository could not confirm
- Validator result

Leave the generated workflow uncommitted unless the user asks for a commit. Never push unless asked.
