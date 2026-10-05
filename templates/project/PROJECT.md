<!-- INSTALLER: Source for .agent/PROJECT.md. Fill every {{PLACEHOLDER}} from repository evidence. Delete any section with nothing project-specific to say. Link to existing docs instead of restating them. Target: under 120 lines. Delete every INSTALLER note. -->

# {{PROJECT_NAME}}

{{ONE_OR_TWO_SENTENCES_ON_WHAT_THIS_PROJECT_IS_AND_WHO_USES_IT}}

## At a glance

| | |
|---|---|
| Topology | {{TOPOLOGY_LABELS}} |
| Languages | {{LANGUAGES_AND_VERSIONS}} |
| Frameworks | {{FRAMEWORKS}} |
| Package manager | {{PACKAGE_OR_WORKSPACE_MANAGER}} |
| Data | {{DATABASE_AND_DATA_ACCESS}} |
| Deployed via | {{DEPLOYMENT_TARGET}} |

<!-- INSTALLER: Remove rows that do not apply (for example Data for a project with no database). -->

## Commands

Run from {{WORKING_DIRECTORY}}.

| Task | Command |
|---|---|
| Install | `{{INSTALL_COMMAND}}` |
| Run locally | `{{RUN_COMMAND}}` |
| Test | `{{TEST_COMMAND}}` |
| Test one file | `{{SINGLE_TEST_COMMAND}}` |
| Lint | `{{LINT_COMMAND}}` |
| Format | `{{FORMAT_COMMAND}}` |
| Type check | `{{TYPECHECK_COMMAND}}` |
| Build | `{{BUILD_COMMAND}}` |

**Before reporting a task complete, run:** `{{VERIFICATION_COMMANDS}}`

<!-- INSTALLER: Use the exact commands from manifest scripts and CI. Remove rows the project has no command for. The verification line should match what CI gates on. -->

## Architecture

{{ARCHITECTURE_IN_THE_PROJECTS_OWN_TERMS}}

{{REPRESENTATIVE_FLOW_FOR_EXAMPLE_REQUEST_TO_DATABASE}}

<!-- INSTALLER: A few lines, describing what exists and not an ideal. If it needs more than about fifteen lines, summarize here and put the detail in context/architecture.md. -->

## Important directories

| Path | Contains |
|---|---|
| `{{PATH}}` | {{WHAT_LIVES_HERE_AND_WHEN_TO_TOUCH_IT}} |

Do not edit: {{GENERATED_OR_VENDORED_PATHS}}

## Conventions

- **Data access:** {{HOW_THE_PROJECT_READS_AND_WRITES_DATA_AND_WHERE_MIGRATIONS_LIVE}}
- **API:** {{ROUTING_VALIDATION_ERROR_SHAPE_VERSIONING}}
- **Auth:** {{WHERE_AUTHENTICATION_AND_AUTHORIZATION_ARE_ENFORCED}}
- **Testing:** {{TEST_LEVELS_LOCATIONS_AND_NAMING}}
- **UI:** {{DESIGN_SYSTEM_LOCATION_AND_STYLING_APPROACH}}
- **Git:** {{BRANCH_AND_COMMIT_CONVENTIONS}}

<!-- INSTALLER: Keep only the bullets this project has. Each bullet names a real file as the example to follow. -->

## Constraints

- {{HARD_CONSTRAINT_AN_AGENT_COULD_VIOLATE_WITHOUT_BEING_TOLD}}

<!-- INSTALLER: Things not obvious from the code: compatibility targets, performance budgets, compliance, areas needing owner approval. Delete the section if there are none. -->

## Canonical documentation

These are authoritative. Read the relevant one before working in its area.

- `{{DOC_PATH}}`: {{WHAT_IT_COVERS}}

## Using this workflow

| Read | When |
|---|---|
| `{{AGENT_FILE_PATH}}` | {{WHEN_TO_READ_IT}} |

<!-- INSTALLER: One row per file actually generated in .agent/, so agents load only what a task needs. Delete this section if PROJECT.md is the only file. -->

Workflow last verified against the repository on {{DATE}}.
