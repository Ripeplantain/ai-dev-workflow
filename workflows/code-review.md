# Workflow: Code Review

Reviews a change, your own or someone else's. Review depth follows the task level (`references/task-complexity.md`).

## Discover

- Read the description or task: what is this change supposed to do?
- Read the whole diff before commenting on any part of it.

## Understand

- Read enough surrounding code to judge the change in context: callers, the module's conventions, related tests.
- For L3 and above, check out and run it.

## Review, in this order

1. **Correctness**: does it do what was asked? Edge cases, error paths, concurrency, data integrity.
2. **Scope**: is everything in the diff needed for the task? Flag unrelated changes (`rules/repo-sanity.md`).
3. **Fit**: does it follow the existing architecture and conventions (`rules/architecture.md`)? Does it duplicate something that exists?
4. **Tests**: do they cover the behavior and fail without the change (`rules/testing.md`)?
5. **Security**: input handling, authorization, secrets, new dependencies (`rules/security.md`).
6. **Operability**: migrations, configuration, compatibility, performance on realistic data.
7. **Clarity**: naming and structure, last, and only where it affects understanding.

## Findings

For each finding give the location, what is wrong, why it matters, and a concrete suggestion. Classify it:

- **Blocking**: incorrect, unsafe, or breaks a project rule.
- **Should fix**: a real problem that is not a blocker.
- **Optional**: a preference. Keep these few.

Verify a finding before reporting it. Do not report style the project's formatter or linter already decides.

## Report

A verdict (approve, approve with changes, request changes), the findings by class, what you checked, and what you did not check.

## Reviewing your own work

Do it as a separate pass after implementation, reading the diff cold. For L3 and above, self-review does not replace independent review.
