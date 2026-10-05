---
name: testing
description: Designs and writes tests that fit a project's existing test suite. Use when a change needs non-trivial test design, when adding coverage to untested code, or when diagnosing flaky or misleading tests.
---

# Specialist Skill: Testing

## Purpose

Produce tests that would catch the defect they exist to catch, written the way this project writes tests.

## When to use

- New behavior with several cases, states, or failure modes
- Characterization tests before a refactor
- Flaky, slow, or misleading tests
- Deciding which level of test a change needs

## When NOT to use

- A change whose test is an obvious copy of a neighboring test: just write it
- Projects with no test suite, unless the task is to introduce one
- As a way to raise a coverage number without a behavior in mind

## Procedure

1. **Learn the local practice.** Framework, locations, naming, fixtures, helpers, and what kind of test covers what kind of code. Read two or three good existing tests.
2. **List the behaviors.** From the requirement, not the implementation: normal cases, boundaries, invalid input, error paths, permissions, concurrency where relevant.
3. **Choose the level.** The lowest level that exercises the behavior for real. Cross-component contracts need an integration test; logic does not need a browser.
4. **Write the test.** One behavior per test, a name that states it, arrange, act, assert. Assert on outcomes, not on internal calls.
5. **Control dependencies** the way the project does. Fake what is slow or external; do not mock the code under test.
6. **Prove it can fail.** Break the code or run against the pre-change version and see the test fail for the right reason.
7. **Make it deterministic.** No reliance on real time, test order, shared state, or the network unless the project's tests are designed for it.

For flaky tests: reproduce by repetition, look for shared state, timing, ordering, and uncontrolled randomness, and fix the cause. Do not add retries or sleeps to hide it.

## Verification

- New tests pass, and fail when the behavior is broken.
- The full suite passes, repeatedly if flakiness was involved.
- Run time and style are in line with comparable tests.

## Expected output

Tests added or changed, the behaviors they cover, behaviors deliberately not covered and why, and the commands run with results.
