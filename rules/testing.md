# Rule: Testing

## Follow the project's testing practice

- Use the existing test framework, file locations, naming, fixtures, and helpers.
- Match the level of test the project uses for similar code. Do not introduce a new kind of test or a new tool without being asked.
- If the project has no tests, do not build a test framework as a side effect. Verify by the means the project does use, and say so.

## What to test

- Behavior changes get a test that fails before the change and passes after.
- Bug fixes get a regression test that reproduces the bug.
- Test behavior through the public interface, not implementation detail.
- Cover the edge cases the change creates: empty, boundary, error, and permission paths where they apply.

## What not to do

- Do not weaken, skip, or delete a test to make a change pass. If a test is wrong, say why and fix it deliberately.
- Do not add tests that assert nothing meaningful to raise coverage.
- Do not mock the thing under test.

## Running tests

- Run the narrowest relevant tests while working, then the project's full verification before finishing.
- Depth scales with task level (`references/task-complexity.md`).
- Report the exact commands and results. If something could not be run, say what and why.
