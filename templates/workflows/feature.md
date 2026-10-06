<!-- INSTALLER: Source for .agent/workflows/feature.md. Bind each step to this project's real paths and commands. Reference only .agent/ files that exist. Delete every INSTALLER note. -->

# Workflow: Feature

Task levels are defined in `.agent/rules/engineering.md`. L0 and L1 need only Implement, Verify, and Report.

## 1. Understand

- Restate the expected behavior and what is out of scope.
- Read the closest existing feature end to end. {{WHERE_FEATURES_LIVE_AND_A_GOOD_EXAMPLE}}
- Identify what the change touches: {{TYPICAL_TOUCHPOINTS_FOR_A_FEATURE_IN_THIS_PROJECT}}.

<!-- INSTALLER: Touchpoints are the places a typical feature here must change, for example route, service, schema, migration, client, tests, docs. -->

## 2. Classify and plan

- Assign a level. Raise it for {{HIGH_RISK_AREAS_IN_THIS_PROJECT}}.
- L2: a short list of changes and tests. L3 and above: a written plan with risks and rollback, agreed before implementing.

## 3. Implement

Typical order in this project:

{{ORDERED_IMPLEMENTATION_STEPS_FOR_A_TYPICAL_FEATURE}}

- Work on a task branch named by the project's feature pattern; commit each unit once it is coherent and green ({{GIT_RULES_LOCATION}}).
- Reuse existing code before adding new code.
- Add tests alongside: {{WHAT_TESTS_A_FEATURE_NEEDS_HERE}}.
- {{UI_STEP_IF_APPLICABLE}}

## 4. Verify

- `{{VERIFICATION_COMMANDS}}`
- Exercise it: {{HOW_TO_RUN_AND_TRY_THE_FEATURE_LOCALLY}}

## 5. Review and clean

- Read the diff as a reviewer. Remove anything the task did not require.
- Update {{DOCS_THAT_MUST_STAY_IN_SYNC}} if the behavior they describe changed.

## 6. Report

What changed, commands run and results, what was not verified, follow-ups.
