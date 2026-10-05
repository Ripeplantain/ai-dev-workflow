# Refactoring Skill

## Purpose

Improve internal structure while preserving externally observable behavior.

## Use when

The task explicitly changes structure, duplication, readability, or maintainability without intended behavior change.

## Do not use when

The request is a feature, bug fix, or migration where a dedicated workflow owns the scope.

## Procedure

1. Establish behavior, callers, contracts, and invariants.
2. Confirm the structural problem and define a measurable or observable goal.
3. Choose the smallest compatible transformation.
4. Make incremental changes that remain verifiable.
5. Preserve naming and architecture conventions unless migration is explicit.
6. Remove obsolete code only when references and generated usage are understood.

## Verification

Run focused behavioral tests plus relevant type, lint, build, and API compatibility checks. Review the diff for hidden behavior changes.

## Expected output

Structural goal, preserved invariants, changed scope, verification evidence, and any discovered follow-up.

