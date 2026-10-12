<!-- INSTALLER: Source for .agent/rules/engineering.md. Write for medium and large repos; on a small repo the role docs carry this and the file is skipped. Carries the project's architecture, task sizing, and Git conventions. On a large repo the architecture section may move to its own .agent/rules/architecture.md, leaving a pointer here. Replace every generic line with this project's specific version. Delete every INSTALLER note. -->

# Engineering

Applies to every change. Project facts and commands are in `.agent/PROJECT.md`. Hard stops are in `.agent/rules/checkpoints.md`.

## Understand before changing

- Read the code you will change, its callers, and its tests.
- Find the comparable existing implementation and follow it. Good references here: {{REFERENCE_IMPLEMENTATIONS_BY_KIND}}.
- State what you do not know. Resolve it by reading or running, not by assuming.

## Preserve the architecture

{{LAYERS_OR_MODULES_AND_ALLOWED_DEPENDENCY_DIRECTION}}

- New code goes where equivalent code already lives: {{PLACEMENT_RULES}}.
- Use the existing mechanisms for {{CONFIG_ERRORS_LOGGING_VALIDATION_DATA_ACCESS_AS_APPLICABLE}}.
- Do not introduce a new architectural pattern, layer, or framework — not Clean Architecture, hexagonal, DDD, CQRS, or the repository pattern — because it is considered good practice elsewhere. A style this project does not use is a cost, not an improvement. If the task seems to require one, stop and raise it.

<!-- INSTALLER: Describe the architecture that exists, in the project's own terms, naming real directories. Do not rename its layers to match a textbook pattern, and do not describe an aspiration as the current state. Where the code is inconsistent, name the dominant or most recent pattern and say that is the one to follow. -->

## Smallest correct change

- Do what the task requires and nothing else.
- Extend existing code before adding new code. Add new code before adding a new abstraction.
- No speculative flexibility: no options, hooks, or layers for needs nobody has stated.
- New dependencies need a stated reason and are a checkpoint. {{DEPENDENCY_POLICY_IF_ANY}}

## Scale effort to the task

| Level | Meaning | In this project |
|---|---|---|
| L0 | Trivial | {{L0_EXAMPLES}} |
| L1 | Small, localized | {{L1_EXAMPLES}} |
| L2 | Standard feature or fix | {{L2_EXAMPLES}} |
| L3 | Significant, cross-cutting | {{L3_EXAMPLES}} |
| L4 | Critical or architectural | {{L4_EXAMPLES}} |

L0–L1: change, check, self-review. L2: brief plan, tests, separate review pass. L3–L4: written plan agreed first, independent review.

Raise the level by at least one when the task touches authentication, authorization, sessions, secrets, or cryptography; money or irreversible operations; stored data shape, migration, or deletion; a public contract (API, event schema, library interface, CLI flags); shared code used across modules; or code with no tests. Lower the ceremony, never the care. If a task turns out bigger than classified, stop, reclassify, and say why.

<!-- INSTALLER: Use real examples from this codebase's domain, for instance "L3: anything under src/billing or a schema migration". -->

## Code conventions

{{NAMING_ERROR_HANDLING_AND_STYLE_CONVENTIONS_NOT_ENFORCED_BY_TOOLING}}

Formatting and lint rules are enforced by {{FORMATTER_AND_LINTER}}; run them, do not restate them.

## Git

- Branch before the first edit: {{BRANCH_CONVENTION}}. Never commit to `{{DEFAULT_BRANCH}}` unless told to.
- Check `git status` before starting. Do not discard or absorb changes that were already in the working tree.
- Commit each unit as soon as it is coherent and its tests pass, rather than saving commits for the end. One unit per commit: something a reader can review and revert on its own.
- Stage by path. Never `git add -A`, `git add .`, or `git commit -a`.
- Messages: {{COMMIT_MESSAGE_CONVENTION}}
- Commit, push, PR, and merge are checkpoints — see `.agent/rules/checkpoints.md`.

<!-- INSTALLER: Use the project's own branch and message conventions where the repository states them or the user gave them; otherwise the defaults are <type>/<short-slug> branches and "type(scope): lowercase claim, no period" messages. If branch patterns differ by kind of work, replace the branch bullet with a sub-list, one line per kind (feature, bug fix, and any others the project names), each with its pattern, an example, and its base branch if it is not the default. -->

## Verify, then claim

Run `{{VERIFICATION_COMMANDS}}` before reporting completion. Report exactly what was run and what happened. A check that could not be run is reported as not run — never as passing. A failing check is reported as failing, with its output, never worked around or hidden.
