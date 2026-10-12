# Workflow templates

Each becomes `.agent/workflows/<name>.md`. Only write the ones the repo needs (`references/selection.md`). Keep each under ~30 lines and use the repo's real commands, not these generic ones.

Every workflow names the branch pattern for its own kind of work, taken from `PROJECT.md` › Branches and release.

## Task size

Put this once, at the top of `feature.md`, and reference it from the others. Sizing lives in `rules/engineering.md` when that file is written (medium/large); on a small repo, inline these three lines instead:

> L0–L1 (typo, localized fix): change, check, self-review — no plan.
> L2 (normal feature or fix): brief plan, tests, separate review pass.
> L3–L4 (cross-module, auth, money, data shape, public contract): written plan agreed first, independent review.

## Done means

Referenced by every workflow's last step. No line is skipped silently: if one does not apply or could not be met, the report says so.

- The requested behavior works, including the edge and error cases the change creates, and nothing that worked before is broken.
- Tests added or updated and passing; `{{VERIFICATION_COMMANDS}}` pass. The exact commands and results are in the report.
- Follows the existing architecture and conventions; reuses what existed; no new dependency without a stated reason.
- The diff contains only what the task required — no debug output, dead code, scratch files, or stray TODOs.
- No secrets in code, tests, logs, or commits.
- The report says what changed, how it was verified, what was **not** verified, and any follow-up.

## feature.md

1. **planner**: restate the goal and the acceptance checks (the command or behaviour that proves it works). List files to touch. Mark every step that hits a checkpoint. Stop for user approval if the plan touches a checkpoint or more than {{~10}} files.
2. **implementer**: build it, following the closest existing feature. `{{typecheck}}` and `{{lint}}` pass.
3. **tester**: tests added/updated next to existing ones; `{{test}}` passes.
4. **reviewer**: verdict. Blocking → back to implementer.
5. **Main agent stops**: check against "Done means", report changes, suggest commit message(s). Commit is a checkpoint.

## fix.md

1. **investigator** (or main agent): reproduce with the smallest reliable case, then trace symptom → cause with file:line evidence. Confirm the cause by turning the failure on and off; do not stop at a plausible one. Check whether the same mistake exists in sibling code.
2. **tester**: write a failing test that captures the bug and fails for the right reason.
3. **implementer**: smallest fix that removes the cause, not the symptom. No refactoring on the way. The new test passes.
4. **reviewer**: check the fix, the test, and the sibling locations.
5. Stop at the commit checkpoint. Report cause, evidence, other affected locations, and residual risk.

## refactor.md (only when structural change is a regular task here)

1. **planner**: state what becomes easier and how you will know it worked. Confirm a refactor was actually requested — an unrequested one inside another task breaks `rules/repo-sanity.md`. Find every use, including strings, config, generated code, and external consumers.
2. **tester**: confirm tests cover current behavior; if not, add characterization tests that pin what the code does now, quirks included.
3. **implementer**: one kind of transformation per step — move, rename, extract, inline — each step leaving the code green. Run `{{test}}` after every step; a failure means the last step changed behavior, so revert and take a smaller one. Migrate callers fully, then delete the old path: never leave two implementations.
4. **reviewer**: the diff should read as a sequence of mechanical moves. Behavior, public interfaces, and outputs unchanged unless the plan said otherwise.
5. Stop at the commit checkpoint. Record further improvements as follow-ups rather than doing them.

## migration.md (only with a database with migrations, or another recurring migration type)

Always L3 or above.

1. **planner**: define start state, end state, and why now. Find how this repo has done it before ({{migration dir and tool}}). List everything that reads or writes what is changing, including jobs, reports, and clients you do not deploy. Write the plan and get it agreed: steps in order, each deployable alone; the compatibility window (expand → migrate → contract) when old code and new schema must coexist; the rollback for each step and the point after which rollback is impossible.
2. **implementer** / **data-engineer**: use `{{migration tool}}` and the repo's conventions. Never edit a migration already applied elsewhere. Keep schema, data, and code changes in separate steps. Make data changes idempotent and bounded.
3. **tester**: run the migration forward on a realistic local dataset and run the rollback. Run `{{test}}` against the migrated state. Report before/after row counts.
4. **reviewer**: ordering, rollback, locking and downtime behavior, data-loss paths. Independent review is required.
5. Every step that runs `{{db commands}}`, pushes, or tags is a checkpoint. Shared or production data is never touched without one.

## release.md (only with release branches or tags)

Describe the repo's actual release train: branch from, naming (`{{release/x.y.z-dev}}`, `{{hot-fix/...}}`), version bump location, changelog, CI gates. Every step that pushes or tags is a checkpoint.

## data-change.md / prompt-change.md

See `references/data-ai.md`.

## Do not generate

These were separate workflows in v1 and are deliberately not written as files now, because the content already has a home and a second copy drifts:

| Not a workflow | Where it lives instead |
|---|---|
| code-review | the reviewer role doc (`templates/agents/role-bodies.md`) and step 4 of every workflow above |
| investigation | the investigator role doc; it is a role's whole job, not a task type |
| ui-feature | `rules/design-system.md`, applied during `feature.md` |
