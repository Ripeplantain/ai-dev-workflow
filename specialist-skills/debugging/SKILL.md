---
name: debugging
description: Finds the root cause of incorrect behavior with evidence. Use for defects, regressions, failing checks, or unexplained runtime behavior where the cause is not already known.
---

# Specialist Skill: Debugging

## Purpose

Find the real cause of incorrect behavior and prove it, so the fix is small and correct.

## When to use

- A defect, regression, flaky or failing test, or behavior nobody can explain
- A previous fix did not hold

## When NOT to use

- The cause is already known and confirmed: go straight to the bugfix workflow
- The "bug" is a missing feature: use the feature workflow
- The question is how something works, with nothing broken: use the investigation workflow

## Procedure

1. **Define.** Expected behavior, observed behavior, and when it started if known.
2. **Reproduce.** Build the smallest reliable reproduction. For intermittent failures, find what raises the failure rate (load, ordering, timing, data).
3. **Gather evidence.** Error text, stack traces, logs, recent changes (`git log`, `git bisect` when there is a known good state), environment differences.
4. **Narrow.** Halve the search space each step: by commit, by input, by layer. Trace the real execution path instead of reading code you assume is involved.
5. **Hypothesize and test.** State one hypothesis and the observation that would disprove it. Test it. Change one thing at a time.
6. **Confirm the cause.** You can explain every symptom, and you can turn the failure on and off.
7. **Look sideways.** Check for the same mistake in sibling code.
8. **Hand over** to the bugfix workflow for the regression test and the fix.

## Verification

- The reproduction fails before the fix and passes after.
- The explanation accounts for all observed symptoms, not most of them.
- All temporary logging and instrumentation is removed.

## Expected output

The cause with its evidence, the reproduction, hypotheses ruled out, other affected locations, and what remains uncertain. If the cause was not found, say so and list what was eliminated.
