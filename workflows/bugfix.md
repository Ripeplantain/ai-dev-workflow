# Workflow: Bugfix

Corrects incorrect behavior at its cause. Use the debugging specialist skill (`specialist-skills/debugging/SKILL.md`) when the cause is not obvious.

## Discover

- State expected behavior, observed behavior, and impact.
- Gather the evidence available: error output, logs, failing test, steps, affected version.

## Understand

- Reproduce the bug with the smallest reliable case. If it cannot be reproduced, say so and state what evidence you are relying on instead.
- Trace from the symptom to the cause. Confirm the cause with evidence, not plausibility.
- Check whether the same mistake exists in sibling code.

## Classify

Usually L1 or L2. Raise it if the fix touches shared code, data integrity, security, or a public contract (`references/task-complexity.md`).

## Plan

Choose the smallest change that removes the cause. If the proper fix is large, say so and offer the choice between it and a contained mitigation; do not silently pick.

## Implement

- Work on a task branch and commit each unit once it is coherent and green (`specialist-skills/commit/SKILL.md`).
- Write a regression test that fails for the right reason first, when the project has tests.
- Fix the cause. Do not paper over the symptom, and do not refactor on the way.

## Verify

- The regression test passes, the original reproduction no longer fails, and affected tests and standard checks pass.

## Review

Read the diff. Confirm it contains the fix, the test, and nothing else.

## Clean

Remove instrumentation and reproduction scratch files.

## Report

Cause, fix, evidence that it works, other places with the same problem (fixed or noted), and residual risk.
