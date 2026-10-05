<!-- INSTALLER: Source for .agent/context/architecture.md. Generate only when the architecture cannot be summarized in the Architecture section of PROJECT.md. If the project already has an architecture document, link to it from PROJECT.md and do not generate this file. Describe what exists, in the project's own terms. Delete every INSTALLER note. -->

# Architecture

Read before any change that crosses module boundaries or adds a new kind of component.

## Overview

{{WHAT_THE_SYSTEM_IS_MADE_OF_AND_HOW_THE_PARTS_RELATE}}

```text
{{SIMPLE_DIAGRAM_OF_COMPONENTS_AND_DEPENDENCY_DIRECTION}}
```

## Components

| Component | Path | Responsibility | Depends on |
|---|---|---|---|
| {{COMPONENT}} | `{{PATH}}` | {{RESPONSIBILITY}} | {{ALLOWED_DEPENDENCIES}} |

## How a request flows

{{STEP_BY_STEP_TRACE_OF_ONE_REPRESENTATIVE_FLOW_WITH_FILE_REFERENCES}}

## Boundaries and rules

- {{DEPENDENCY_DIRECTION_RULE}}
- {{WHAT_MUST_NOT_BE_IMPORTED_OR_CALLED_FROM_WHERE}}
- Enforced by: {{LINT_RULE_OR_TOOL_IF_ANY}}

## Cross-cutting mechanisms

| Concern | How it is done here | Where |
|---|---|---|
| {{CONCERN_FOR_EXAMPLE_ERRORS_CONFIG_LOGGING_AUTH}} | {{MECHANISM}} | `{{PATH}}` |

## External systems

| System | Used for | Accessed through |
|---|---|---|
| {{EXTERNAL_SYSTEM}} | {{PURPOSE}} | `{{CLIENT_OR_ADAPTER_PATH}}` |

## Known inconsistencies

{{AREAS_THAT_FOLLOW_AN_OLDER_PATTERN_AND_WHICH_PATTERN_NEW_CODE_SHOULD_FOLLOW}}

<!-- INSTALLER: Delete any section with nothing to record. Do not present an intended future architecture as the current one. -->
