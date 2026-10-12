<!-- INSTALLER: Source for .agent/rules/repo-sanity.md. Written on every install: it is the rule that most changes what an agent adds to a repo. The value of this file is the project-specific "look here first" table; fill it with real locations or delete the table. Delete every INSTALLER note. -->

# Repo sanity

Add as little to this repository as correctness allows. Every file, function, and dependency is something a person has to maintain.

## Before creating anything

1. Is it necessary?
2. Does it already exist here, possibly under another name?
3. Will it be used?
4. Is this the right location?
5. Can it be done with fewer files or less code?

Search before you create. Look for an existing utility, component, type, constant, or script that already does the job.

## Look here first

| Before adding a new | Check |
|---|---|
| {{KIND_OF_THING_FOR_EXAMPLE_UTILITY}} | `{{WHERE_EXISTING_ONES_LIVE}}` |

<!-- INSTALLER: One row per kind of shared thing this project has: utilities, components, hooks, types, constants, API clients, test helpers, scripts. Only rows with a real location. Delete the table if the project has no shared locations worth naming. -->

## Do not add

| Avoid | Do instead |
|---|---|
| Duplicate utilities or components | Reuse or extend the existing one |
| Wrappers that only forward a call | Call the thing directly |
| Speculative abstractions | Write the concrete case; abstract on the third real use |
| Unnecessary dependencies | Use what is already installed |
| Parallel implementations (`*-v2`, `*-new`, `*-old`, `copy of`) | Change the existing implementation in place |
| Temporary or one-off scripts | Run the command; delete anything left behind |
| Unrequested documentation files | Update the document that already covers the topic |
| Dead code and commented-out code | Delete it; version control remembers |
| Unrelated formatting changes | Format only the lines you changed |
| Unrelated refactors | Note them for a separate change |

## Never edit or commit

{{GENERATED_VENDORED_BUILD_OUTPUT_AND_LOCAL_ENV_PATHS}}

## Before finishing

- Read the full diff. Every changed line should trace to the task.
- Remove debug output, scratch files, stray TODOs, and unused imports you introduced.
- Confirm no generated or build output was added to version control.
- If the diff is larger than the task suggests, shrink it or explain why.
