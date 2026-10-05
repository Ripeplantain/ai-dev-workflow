# Workflow: Refactor

Changes structure without changing behavior. Use the refactoring specialist skill (`specialist-skills/refactoring/SKILL.md`) for anything beyond a local cleanup.

## Discover

- State the goal: what becomes easier or safer after this, and for whom.
- Confirm a refactor was actually requested. An unrequested refactor inside another task violates `rules/repo-sanity.md`.

## Understand

- Map what uses the code being restructured, including dynamic references, configuration, and external consumers.
- Establish how current behavior is verified. If there are no tests covering it, add characterization tests first or agree another safety net.

## Classify

L2 if contained in a module. L3 if it crosses modules or changes a shared interface. L4 if it changes the architecture (`references/task-complexity.md`, `rules/architecture.md`).

## Plan

Break the work into steps that each leave the code working. Decide what is out of scope and write it down.

## Implement

- Work on a task branch and commit each unit once it is coherent and green (`specialist-skills/commit/SKILL.md`).
- One kind of change per step: move, rename, extract, or inline. Not several at once.
- No behavior changes and no feature work mixed in. If you find a bug, record it; fix it separately.
- Remove the old structure. Do not leave both versions in place.

## Verify

Run the tests after each step and the full checks at the end. Behavior, public interfaces, and outputs must be unchanged unless the plan said otherwise.

## Review

The diff should be explainable as a sequence of mechanical moves. Anything that is not gets a second look.

## Clean

Delete dead code, obsolete tests, and stale references in docs and configuration.

## Report

What was restructured, proof that behavior is unchanged, and what was deliberately left alone.
