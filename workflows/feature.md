# Workflow: Feature

Adds new behavior. Depth follows the task level in `references/task-complexity.md`. For UI work, use `workflows/ui-feature.md` alongside this.

## Discover

- Read the request and restate the expected behavior, including what is out of scope.
- Find the closest existing feature and read it end to end: entry point, logic, data access, tests.

## Understand

- Identify every place the change touches and what depends on those places.
- Note the conventions the comparable feature follows (`rules/architecture.md`).

## Classify

Assign L0 to L4. Raise the level for auth, data, money, public contracts, or cross-module reach.

## Plan

- L1: a sentence. L2: a short list of changes and tests. L3 and above: a written plan with risks, rollout, and rollback, agreed before implementing.
- Resolve open questions now. Ask the user only for decisions the code cannot answer.

## Implement

- Work on a task branch and commit each unit once it is coherent and green (`specialist-skills/commit/SKILL.md`).
- Build in the existing structure, reusing existing utilities and components (`rules/repo-sanity.md`).
- Keep the change small and in reviewable steps. Add tests alongside the code (`rules/testing.md`).

## Verify

- Run the new tests, the affected tests, then the project's standard checks.
- Exercise the feature the way a user or caller would, where that is possible.

## Review

Read your own diff as a reviewer would (`workflows/code-review.md`). L3 and above: independent review.

## Clean

Remove debug code, scratch files, and anything unrelated. Update the existing documentation that describes the changed behavior.

## Report

What changed, how it was verified (commands and results), what was not verified, and any follow-up. Check against `references/definition-of-done.md`.
