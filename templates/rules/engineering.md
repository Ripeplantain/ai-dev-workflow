<!-- INSTALLER: Source for .agent/rules/engineering.md. This file also carries the project's architecture and Git conventions unless they are large enough to need their own file. Replace generic lines with this project's specific version. Delete every INSTALLER note. -->

# Rule: Engineering

Applies to every change. Project facts and commands are in `.agent/PROJECT.md`.

## Understand before changing

- Read the code you will change, its callers, and its tests.
- Find the comparable existing implementation and follow it. Good references in this project: {{REFERENCE_IMPLEMENTATIONS_BY_KIND}}.

## Preserve the architecture

{{LAYERS_OR_MODULES_AND_ALLOWED_DEPENDENCY_DIRECTION}}

- New code goes where equivalent code already lives: {{PLACEMENT_RULES}}.
- Use the existing mechanisms for {{CONFIG_ERRORS_LOGGING_VALIDATION_DATA_ACCESS_AS_APPLICABLE}}.
- Do not introduce a new architectural pattern, layer, or framework. If the task seems to require one, stop and raise it.

<!-- INSTALLER: Describe the architecture that exists, in the project's own terms. Name real directories. -->

## Smallest correct change

- Do what the task requires and nothing else.
- Extend before adding; add before abstracting.
- New dependencies need a stated reason. {{DEPENDENCY_POLICY_IF_ANY}}

## Scale effort to the task

| Level | Meaning | In this project |
|---|---|---|
| L0 | Trivial | {{L0_EXAMPLES}} |
| L1 | Small, localized | {{L1_EXAMPLES}} |
| L2 | Standard feature or fix | {{L2_EXAMPLES}} |
| L3 | Significant, cross-cutting | {{L3_EXAMPLES}} |
| L4 | Critical or architectural | {{L4_EXAMPLES}} |

L0 and L1: change, check, self-review. L2: brief plan, tests, separate review pass. L3 and L4: written plan agreed first, independent review. If a task turns out bigger than classified, stop and reclassify.

<!-- INSTALLER: Use real examples from this codebase's domain, for instance "L3: anything under src/billing or a schema migration". -->

## Code conventions

{{NAMING_ERROR_HANDLING_AND_STYLE_CONVENTIONS_NOT_ENFORCED_BY_TOOLING}}

Formatting and lint rules are enforced by {{FORMATTER_AND_LINTER}}; run them, do not restate them.

## Git

- Branch before the first edit: {{BRANCH_CONVENTION}}. Never commit to `{{DEFAULT_BRANCH}}` unless told to.
- Commit each unit as soon as it is coherent and its tests pass. Stage by path; never `git add -A`, `git add .`, or `git commit -a`.
- Messages: {{COMMIT_MESSAGE_CONVENTION}}
- No `Co-Authored-By`, `Generated with`, or similar trailers, and no attribution anywhere in files or pull requests.
- Do not push, open a pull request, or merge unless asked. Never force-push or bypass hooks.
- {{REFERENCE_TO_COMMIT_SKILL_IF_GENERATED}}

<!-- INSTALLER: Use the project's own branch and message conventions where evidence shows them; otherwise the defaults are <type>/<short-slug> branches and "type(scope): lowercase claim, no period" messages. Point to .agent/skills/commit.md only if that file is generated; otherwise delete the last bullet. -->

## Verify, then claim

Run `{{VERIFICATION_COMMANDS}}` before reporting completion. Report what was run and the result. Anything not run is reported as not run.
