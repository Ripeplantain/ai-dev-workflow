<!-- INSTALLER: Source for .agent/WORKFLOW.md in SMALL projects only (standard and large projects use templates/workflows/ instead). Keep it to one screen. Delete every INSTALLER note. If RULES.md is not generated, remove the reference to it. -->

# Workflow

How to carry out a task in this project. Context is in `.agent/PROJECT.md`; constraints are in `.agent/RULES.md`.

## Size the task first

| Size | Examples | What it needs |
|---|---|---|
| Trivial | Typo, formatting, copy | Make the change, check the diff |
| Small | Localized bug, small addition | Read the surrounding code, change, test, self-review |
| Standard | A feature or a fix across a few files | All steps below |
| Significant | Changes to {{HIGH_RISK_AREAS_IN_THIS_PROJECT}}, anything hard to undo | All steps, plus a written plan agreed before implementing |

## Steps

1. **Understand.** Restate what is wanted. Read the code involved and one comparable existing example.
2. **Plan.** List the changes and how you will verify them. Ask about anything the code cannot answer.
3. **Implement.** Make the smallest change that does the job, in the existing structure.
4. **Verify.** Run `{{VERIFICATION_COMMANDS}}`. {{HOW_TO_EXERCISE_THE_CHANGE_MANUALLY}}
5. **Review.** Read your own diff from the top. Remove anything the task did not require.
6. **Report.** What changed, what you ran and the result, what you did not verify, any follow-up.

## Fixing a bug

Reproduce it first. Find the cause, not just the symptom. {{REGRESSION_TEST_EXPECTATION}} Check whether the same mistake exists nearby.

<!-- INSTALLER: Add a short section for any other task type this project does regularly (for example releasing, adding a command, adding a migration), with the real steps. Do not add sections for task types the project does not have. -->
