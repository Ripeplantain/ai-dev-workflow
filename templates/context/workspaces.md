<!-- INSTALLER: Source for .agent/context/workspaces.md. Generate only for monorepos and multi-service repositories. Add a per-workspace section only where a workspace genuinely needs different behavior. Delete every INSTALLER note. -->

# Workspaces

Read before any change that touches more than one workspace, or any shared package.

Workspaces are defined by {{WORKSPACE_DEFINITION_FILE_AND_TOOL}}.

## Units

| Path | Kind | Purpose |
|---|---|---|
| `{{PATH}}` | {{APP_SERVICE_PACKAGE_OR_TOOLING}} | {{PURPOSE}} |

## Dependency direction

{{ALLOWED_DIRECTION_FOR_EXAMPLE_APPS_DEPEND_ON_PACKAGES_NEVER_THE_REVERSE}}

- Must never depend on anything internal: {{LEAF_PACKAGES}}
- Enforced by: {{BOUNDARY_TOOL_OR_LINT_RULE_IF_ANY}}

## Where shared code belongs

| Kind of code | Package |
|---|---|
| {{KIND_FOR_EXAMPLE_UI_COMPONENTS_DB_SCHEMA_TYPES}} | `{{PACKAGE_PATH}}` |

Extend the shared package. Do not copy shared code into an app.

## Commands

| Task | Command |
|---|---|
| One workspace | `{{FILTERED_COMMAND_PATTERN}}` |
| Affected by current changes | `{{AFFECTED_COMMAND}}` |
| Everything | `{{FULL_COMMAND}}` |

## Changing a shared package

{{WHICH_CONSUMERS_TO_BUILD_AND_TEST_AND_HOW_VERSIONS_OR_CHANGESETS_ARE_HANDLED}}

## Workspace-specific notes

### {{WORKSPACE_PATH}}

{{WHAT_IS_DIFFERENT_HERE_LANGUAGE_TOOLCHAIN_ARCHITECTURE_OR_CONSTRAINTS}}

<!-- INSTALLER: Delete this whole section if no workspace differs meaningfully from the rest. -->
