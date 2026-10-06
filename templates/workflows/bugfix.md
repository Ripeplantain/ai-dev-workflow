<!-- INSTALLER: Source for .agent/workflows/bugfix.md. Bind each step to this project's real tools. Reference only .agent/ files that exist. Delete every INSTALLER note. -->

# Workflow: Bugfix

## 1. Define

State expected behavior, observed behavior, and impact. Collect the evidence: {{WHERE_ERRORS_AND_LOGS_ARE_FOUND}}.

## 2. Reproduce

Reproduce with the smallest reliable case: {{HOW_TO_REPRODUCE_LOCALLY_IN_THIS_PROJECT}}. If it cannot be reproduced, say so and state what evidence you are relying on.

## 3. Find the cause

- Trace from the symptom to the cause and confirm it with evidence.
- {{DEBUGGING_AIDS_AVAILABLE_FOR_EXAMPLE_DEBUG_FLAGS_OR_LOG_LEVELS}}
- Check whether sibling code has the same mistake.

## 4. Classify

Usually L1 or L2. Raise the level if the fix touches {{HIGH_RISK_AREAS_IN_THIS_PROJECT}} or shared code.

## 5. Fix

- Write a regression test that fails for the right reason first: {{WHERE_REGRESSION_TESTS_GO}}.
- Make the smallest change that removes the cause. No refactoring on the way.
- Work on a task branch named by the project's bug-fix pattern, and commit the fix with its test as one unit ({{GIT_RULES_LOCATION}}).

## 6. Verify

- The regression test passes and the original reproduction no longer fails.
- `{{VERIFICATION_COMMANDS}}`

## 7. Clean and report

Remove instrumentation and scratch files. Report the cause, the fix, the evidence it works, other affected places, and residual risk.
