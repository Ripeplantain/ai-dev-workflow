# Rule: Engineering

The baseline every workflow and specialist skill inherits.

## Understand before changing

- Read the code you are about to change, its callers, and its tests.
- Find how the repository already solves a similar problem and follow that.
- State what you do not know. Resolve it by reading or running, not by assuming.

## Smallest correct change

- Change what the task requires and nothing else.
- Extend existing code before adding new code. Add new code before adding a new abstraction.
- No speculative flexibility: no options, hooks, or layers for needs nobody has stated.
- No new dependency when the standard library or an existing dependency does the job. A new dependency needs a stated reason.

## Match the repository

- Follow existing naming, file placement, error handling, logging, and formatting.
- Use the project's own commands for build, test, lint, and format.
- Preserve the existing architecture (see `rules/architecture.md`).

## Scale effort to the task

Classify every task with `references/task-complexity.md`. A typo does not get a plan; an authorization change does not get a one-line review.

## Verify, then claim

- Run the relevant checks before saying something works.
- Report exactly what was run and what happened. A check that could not be run is reported as not run.
- A failing check is reported as failing, with the output, never worked around or hidden.

## Leave it clean

Before finishing, apply `rules/repo-sanity.md` and `references/definition-of-done.md`.
