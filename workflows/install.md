# Workflow: Install

Creates `.agent/` in a target repository that does not have one. Governed by `rules/project-installation.md`.

## 1. Inspect

- Confirm the target repository root (the Git top level unless the user named a subdirectory).
- Run `git status`. Note uncommitted changes so your diff stays separable from them.
- List the root and one or two levels of the main source directories.
- If `.agent/` already exists, stop and switch to `workflows/update.md`.
- If another directory already holds an AI workflow (for example `.agents/` with project context, rules, or task workflows in it), stop and switch to `workflows/update.md`. Do not create `.agent/` beside it. A directory holding only installed skills or tool settings does not count; see "An existing workflow under another name" in `SKILL.md`.

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

## 6. Ask

Follow the Questions section of `SKILL.md`. Go through the unknowns and conflicts from discovery and the keep-or-skip list from step 5, and pick out the ones where the answer changes a command, a rule, or whether a file exists. Ask them together, each with the evidence you found and a recommended option, then wait for the answers before loading templates.

Always include the branch naming convention unless a document, hook, or CI filter states it. Ask for it per kind of work (features, bug fixes, and whatever else the team distinguishes, such as hotfixes or releases), with the base branch for each. Show the names you observed, recommend the patterns they suggest (or `<type>/<short-slug>` if there are none), and write the answer, one line per kind of work, wherever the Git rules go: `PROJECT.md`, `RULES.md` or `rules/engineering.md`, and `skills/commit.md`. Each generated task workflow names the pattern for its own kind of work.

Other typical install questions: which package manager is canonical when lockfiles disagree, whether to record the commit practice the history shows or a stricter one, where the project deploys when nothing configures it, and whether there are rules for agents that no file states.

If nothing is open, or nobody can answer, continue and note it for the report.

## 7. Load templates

Load only the templates for artifacts marked keep.

- Small project: `templates/project/PROJECT.md` and `templates/project/WORKFLOW.md`, and `templates/project/RULES.md` if kept.
- Otherwise: `templates/project/PROJECT.md` plus the specific files chosen from `templates/agents/`, `templates/rules/`, `templates/workflows/`, `templates/context/`.
- Specialist skills chosen: the matching `specialist-skills/<name>/SKILL.md`.

## 8. Customize

For each file:

- Replace every `{{PLACEHOLDER}}` with a fact from the repository or an answer from step 6.
- Follow each `INSTALLER:` note, then delete it.
- Delete any section the repository gives nothing to say about. An empty or generic section is worse than a missing one.
- Use real commands, real paths, and the project's own vocabulary for its layers and modules.
- Replace generic guidance with the specific local version wherever one exists. "Follow existing patterns" becomes "new endpoints follow `src/routes/orders.ts`".
- Link to existing documentation instead of summarizing it.
- Adjust cross-references so they point only at files you are actually generating.

## 9. Write

- Create `.agent/` and write the files.
- Copy chosen specialist skills to `.agent/skills/<name>.md`, dropping the frontmatter and binding the procedure to the project's tools.
- Add the entry pointer described in `rules/project-installation.md`. Suggested wording:

```markdown
## AI workflow

Project context, rules, and task workflows for AI agents live in `.agent/`.
Start with `.agent/PROJECT.md`.
```

## 10. Validate

- Run `scripts/validate-agent-dir.sh <target-repo-root>` from the skill directory and fix every error.
- Run the verification commands you recorded in `PROJECT.md` when they are safe, fast, and need no credentials (lint, type check, unit tests). The goal is to confirm the commands exist and are spelled correctly. If a command fails for reasons that predate you, record that in the report; do not fix project code.
- Confirm every path mentioned in `.agent/` exists.
- Re-read `PROJECT.md` as an agent who has never seen the repository: could you make a safe change with it?

## 11. Review the diff

Run `git status` and `git diff`. Check that:

- Only `.agent/` and the entry pointer changed.
- Nothing duplicates existing documentation.
- Nothing is generic enough to apply unchanged to any repository. Delete or specialize it.
- No secrets, hostnames, or personal data were copied in.

## 12. Report

Use the completion report format in `SKILL.md`. Leave the changes uncommitted unless the user asked for a commit.
