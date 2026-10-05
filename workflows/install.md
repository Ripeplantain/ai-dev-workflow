# Workflow: Install

Creates `.agent/` in a target repository that does not have one. Governed by `rules/project-installation.md`.

## 1. Inspect

- Confirm the target repository root (the Git top level unless the user named a subdirectory).
- Run `git status`. Note uncommitted changes so your diff stays separable from them.
- List the root and one or two levels of the main source directories.
- If `.agent/` already exists, stop and switch to `workflows/update.md`.

## 2. Read existing instructions

Read every agent instruction file and contributor document listed in `references/repository-discovery.md`. Record:

- What they already cover well (do not restate it).
- What they lack (candidates for `.agent/`).
- Any rule that constrains how you write the workflow.

## 3. Discover

Follow `references/repository-discovery.md`. Collect evidence for each dimension that applies, and record the file each fact came from. Stop exploring a dimension once you can state its facts with confidence; discovery is not an audit of the whole codebase.

Run nothing that changes the repository. Reading manifests, configuration, and CI definitions is usually enough to establish the commands.

## 4. Classify

Decide complexity and topology using `rules/project-installation.md`. Write one sentence of evidence for each. If workspace or multi-service evidence was found, load `references/monorepos.md`. If UI code was found, load `rules/design-system.md` and `references/design-tokens.md`.

## 5. Decide the artifacts

Start from the selection table in `rules/project-installation.md` for the classification. For each candidate file, apply the necessity test and write down keep or skip with a reason. This list becomes part of the report.

Stop here and present the list instead of writing files only if the user asked for a preview or dry run.

## 6. Load templates

Load only the templates for artifacts marked keep.

- Small project: `templates/project/PROJECT.md`, and `templates/project/RULES.md` and `templates/project/WORKFLOW.md` if kept.
- Otherwise: `templates/project/PROJECT.md` plus the specific files chosen from `templates/agents/`, `templates/rules/`, `templates/workflows/`, `templates/context/`.
- Specialist skills chosen: the matching `specialist-skills/<name>/SKILL.md`.

## 7. Customize

For each file:

- Replace every `{{PLACEHOLDER}}` with a fact from the repository.
- Follow each `INSTALLER:` note, then delete it.
- Delete any section the repository gives nothing to say about. An empty or generic section is worse than a missing one.
- Use real commands, real paths, and the project's own vocabulary for its layers and modules.
- Replace generic guidance with the specific local version wherever one exists. "Follow existing patterns" becomes "new endpoints follow `src/routes/orders.ts`".
- Link to existing documentation instead of summarizing it.
- Adjust cross-references so they point only at files you are actually generating.

## 8. Write

- Create `.agent/` and write the files.
- Copy chosen specialist skills to `.agent/skills/<name>.md`, dropping the frontmatter and binding the procedure to the project's tools.
- Add the entry pointer described in `rules/project-installation.md`. Suggested wording:

```markdown
## AI workflow

Project context, rules, and task workflows for AI agents live in `.agent/`.
Start with `.agent/PROJECT.md`.
```

## 9. Validate

- Run `scripts/validate-agent-dir.sh <target-repo-root>` from the skill directory and fix every error.
- Run the verification commands you recorded in `PROJECT.md` when they are safe, fast, and need no credentials (lint, type check, unit tests). The goal is to confirm the commands exist and are spelled correctly. If a command fails for reasons that predate you, record that in the report; do not fix project code.
- Confirm every path mentioned in `.agent/` exists.
- Re-read `PROJECT.md` as an agent who has never seen the repository: could you make a safe change with it?

## 10. Review the diff

Run `git status` and `git diff`. Check that:

- Only `.agent/` and the entry pointer changed.
- Nothing duplicates existing documentation.
- Nothing is generic enough to apply unchanged to any repository. Delete or specialize it.
- No secrets, hostnames, or personal data were copied in.

## 11. Report

Use the completion report format in `SKILL.md`. Leave the changes uncommitted unless the user asked for a commit.
