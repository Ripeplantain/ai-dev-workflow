<!-- INSTALLER: Source for .agent/workflows/refactor.md. Generate only when structural change is a regular task in this codebase. Delete every INSTALLER note. -->

# Workflow: Refactor

Structure changes; behavior does not. Only refactor when it was requested. Inside another task, note the opportunity and leave it.

## 1. Scope

State what becomes easier or safer, and what is out of scope.

## 2. Map usage

Find everything that uses the code being restructured, including {{NON_OBVIOUS_REFERENCES_FOR_EXAMPLE_DYNAMIC_IMPORTS_CONFIG_OR_EXTERNAL_CONSUMERS}}.

## 3. Secure a safety net

Confirm existing tests cover the behavior: `{{COMMAND_TO_RUN_RELEVANT_TESTS}}`. If they do not, add characterization tests first.

## 4. Classify

L2 within one module. L3 across modules or for a shared interface. L4 if it changes the architecture, which needs a written plan and agreement first.

## 5. Change in steps

- One kind of change per step: move, rename, extract, or inline.
- Run the tests after each step, and commit each passing step on the task branch ({{GIT_RULES_LOCATION}}).
- No behavior changes and no feature work mixed in. Record bugs you find; fix them separately.
- Remove the old structure. Do not leave both in place.
- {{PROJECT_SPECIFIC_REFACTOR_CONSTRAINT_FOR_EXAMPLE_PUBLIC_API_STABILITY}}

## 6. Verify

`{{VERIFICATION_COMMANDS}}`. Public interfaces and outputs are unchanged unless the plan said otherwise.

## 7. Clean and report

Delete dead code and stale references in docs and configuration. Report what was restructured, proof behavior is unchanged, and what was left alone.
