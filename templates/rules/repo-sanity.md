<!-- INSTALLER: Source for .agent/rules/repo-sanity.md. The value of this file is the project-specific "look here first" table; fill it with real locations. Delete every INSTALLER note. -->

# Rule: Repository Sanity

Add as little to this repository as correctness allows.

## Before creating anything

1. Is it necessary?
2. Does it already exist here, possibly under another name?
3. Will it be used?
4. Is this the right location?
5. Can it be done with fewer files or less code?

## Look here first

| Before adding a new | Check |
|---|---|
| {{KIND_OF_THING_FOR_EXAMPLE_UTILITY}} | `{{WHERE_EXISTING_ONES_LIVE}}` |

<!-- INSTALLER: One row per kind of shared thing this project has: utilities, components, hooks, types, constants, API clients, test helpers, scripts. Only rows with a real location. -->

## Do not add

- Duplicate utilities or components, or wrappers that only forward a call
- Abstractions for needs nobody has stated
- Dependencies the existing ones already cover
- Parallel implementations alongside the one being replaced
- Temporary scripts, scratch files, or unrequested documentation files
- Dead code or commented-out code
- Formatting changes or refactors unrelated to the task

## Never edit or commit

{{GENERATED_VENDORED_BUILD_OUTPUT_AND_LOCAL_ENV_PATHS}}

## Before finishing

- Read the full diff; every changed line traces to the task.
- Remove debug output, unused imports, and stray TODOs you introduced.
- If the diff is larger than the task suggests, shrink it or explain why.
