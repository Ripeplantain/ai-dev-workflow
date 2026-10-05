# Reference: Definition of Done

A task is done when every applicable line is true. Depth scales with the task level (`references/task-complexity.md`), but no line is skipped silently: if one does not apply or could not be met, the report says so.

## For engineering tasks

**Correct**
- The requested behavior works, including the edge and error cases the change creates.
- Nothing that worked before is broken.

**Verified**
- Relevant tests were added or updated, and they pass.
- The project's standard checks pass: tests, lint, types, build, as the project defines them.
- The exact commands run, and their results, are in the report.

**Fits the repository**
- Follows the existing architecture, conventions, and (for UI) the visual language.
- Reuses what existed; no duplicate utilities, components, or parallel implementations.
- No new dependency without a stated reason.

**Clean**
- The diff contains only what the task required.
- No debug output, dead code, commented-out code, scratch files, or stray TODOs.
- Documentation that describes the changed behavior is updated in place.

**Safe**
- No secrets or sensitive data in code, tests, logs, or commits.
- Security-relevant changes were reviewed as such.
- Migrations and breaking changes have a rollback and stated operator steps.

**Reported**
- What changed, how it was verified, what was not verified, and known risks or follow-ups.
- Work is committed in reviewable units on the task branch, with no attribution trailers. Nothing is on the default branch, pushed, or merged beyond what the user asked.

## For installing or updating `.agent/`

- Every statement traces to evidence in the repository or to the user.
- Only necessary files exist; each passed the necessity test in `rules/project-installation.md`.
- No placeholders, installer notes, or generic filler remain.
- Every path and command mentioned exists; safe verification commands were run.
- Existing instructions and documentation were preserved and are referenced, not duplicated.
- An agent entry file points to `.agent/PROJECT.md`.
- `scripts/validate-agent-dir.sh` passes.
- The diff was reviewed and touches only `.agent/` and the entry pointer.
- The completion report lists created, changed, skipped, verified, and assumed items.
