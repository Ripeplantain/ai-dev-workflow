# Testing Skill

## Purpose

Design and run verification that gives confidence proportional to change risk.

## Use when

Adding tests, selecting a verification plan, diagnosing test failures, or validating a change.

## Do not use when

No behavior or verification decision is involved; do not add tests solely to increase a number.

## Procedure

1. Discover the repository's test layers and commands.
2. Identify changed behavior, boundaries, failure modes, and important invariants.
3. Prefer focused tests at the lowest useful layer; add integration or end-to-end coverage for real boundary behavior.
4. Keep fixtures deterministic and avoid secrets or production data.
5. Run focused checks first, then broaden based on task level and dependency surface.
6. Investigate failures rather than weakening assertions or deleting flaky tests without evidence.

## Verification

Record exact commands, outcomes, skipped layers, and why the selected scope is sufficient.

## Expected output

Test rationale, changed coverage, command results, and remaining gaps.

