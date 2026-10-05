# Debugging Skill

## Purpose

Find and correct the root cause of incorrect behavior with evidence and a focused change.

## Use when

There is a defect, regression, failing check, or unexplained runtime behavior.

## Do not use when

The task is only a planned feature or a broad architecture migration; use the matching workflow and load this skill only for the defect portion.

## Procedure

1. Define expected versus observed behavior and impact.
2. Reproduce with the smallest reliable case or document why reproduction is unavailable.
3. Trace the relevant path from boundary to failure.
4. Form hypotheses and test them with targeted evidence.
5. Identify the root cause and a minimal correction.
6. Add or update a regression test following local conventions.
7. Check adjacent edge cases and review the diff independently.

## Verification

Run the regression check, affected tests, and relevant lint/type/build checks. Report exact commands and any environment limitation.

## Expected output

Cause, fix, regression evidence, residual risk, and follow-up if the diagnosis is incomplete.

