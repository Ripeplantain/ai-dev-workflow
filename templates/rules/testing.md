<!-- INSTALLER: Source for .agent/rules/testing.md. Generate only when the project has tests or a stated testing expectation. Delete every INSTALLER note. -->

# Rule: Testing

## How this project tests

| Kind | Tool | Location and naming | Command |
|---|---|---|---|
| {{TEST_KIND}} | {{TEST_TOOL}} | `{{LOCATION_AND_NAMING_PATTERN}}` | `{{COMMAND}}` |

- Single test: `{{SINGLE_TEST_COMMAND}}`
- Shared fixtures and helpers: `{{FIXTURES_AND_HELPERS_LOCATION}}`
- Requirements to run: {{SERVICES_ENV_OR_SETUP_NEEDED}}
- A test to imitate: `{{EXAMPLE_TEST_FILE}}`

<!-- INSTALLER: One row per kind of test that really exists. Remove bullets that do not apply. -->

## Expectations

- Behavior changes come with a test that fails before the change and passes after.
- Bug fixes come with a regression test.
- {{WHICH_KIND_OF_TEST_FOR_WHICH_KIND_OF_CODE_IN_THIS_PROJECT}}
- {{COVERAGE_OR_CI_GATE_IF_ANY}}

## Do not

- Weaken, skip, or delete a test to make a change pass.
- Introduce a new test framework, runner, or mocking approach.
- {{PROJECT_SPECIFIC_TESTING_PROHIBITION_FOR_EXAMPLE_NO_NETWORK_IN_UNIT_TESTS}}

## Running

Run the narrowest relevant tests while working, then `{{VERIFICATION_COMMANDS}}` before finishing. Report exact commands and results.
