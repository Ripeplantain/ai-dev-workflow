<!-- INSTALLER: Source for .agent/RULES.md in SMALL projects only (standard and large projects use templates/rules/ instead). Keep it to one screen. Replace generic lines with the project's specific version; delete lines that do not apply. Delete every INSTALLER note. -->

# Rules

Read `.agent/PROJECT.md` first. These rules apply to every change.

## Change as little as correctness allows

- Read the code and its tests before changing it. Find how the project already does the same kind of thing and follow that: {{EXAMPLE_FILE_TO_IMITATE}}.
- Reuse existing code before writing new code. Search first.
- No new dependencies, abstractions, wrappers, or files unless the task cannot be done without them.
- No unrelated refactors or formatting. No dead code, commented-out code, or leftover scripts.

## Keep the structure the project has

{{ONE_OR_TWO_LINES_ON_WHERE_THINGS_GO_IN_THIS_PROJECT}}

Do not introduce a new architectural pattern, directory layout, or tool.

## Verify before claiming

- Run `{{VERIFICATION_COMMANDS}}` before saying a task is done.
- {{TESTING_EXPECTATION_FOR_THIS_PROJECT}}
- Report what you ran and what happened. If you could not run something, say so.

<!-- INSTALLER: If the project has no tests, state how changes are verified instead and do not tell agents to add a test framework. -->

## Stay safe

- Never put secrets in code, tests, logs, or commits. Configuration lives in {{CONFIG_LOCATION}}.
- {{PROJECT_SPECIFIC_SAFETY_RULE}}

## Git

- Branch before the first edit: {{BRANCH_CONVENTION}}. Never commit to `{{DEFAULT_BRANCH}}` unless told to.
- Commit each unit as soon as it is coherent and its checks pass. Stage by path; never `git add -A` or `git add .`.
- Messages: {{COMMIT_MESSAGE_CONVENTION}}
- No `Co-Authored-By`, `Generated with`, or similar trailers, and no attribution in files.
- Do not push or merge unless asked.

<!-- INSTALLER: Use the project's own conventions where the repository states them or the user gave them; otherwise default to <type>/<short-slug> branches and "type(scope): lowercase claim, no period" messages. If branch patterns differ by kind of work, replace the branch bullet's placeholder with a sub-list, one line per kind (feature, bug fix, and any others the project names), each with its pattern, an example, and its base branch if it is not the default. -->

## UI

{{WHERE_STYLES_AND_SHARED_COMPONENTS_LIVE}} Reuse existing components and style values before adding new ones.

<!-- INSTALLER: Delete the UI section if the project has no UI. -->
