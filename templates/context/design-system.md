<!-- INSTALLER: Source for .agent/context/design-system.md. Generate only when the project has a real design system with enough to map. For simpler UIs, the locations in rules/design-system.md are enough. Record locations and conventions, never copies of token values. Delete every INSTALLER note. -->

# Design System

Read before building or changing UI. The rule for using it is in `.agent/rules/design-system.md`.

## Source of truth

{{WHAT_THE_DESIGN_SYSTEM_IS_AND_WHERE_ITS_SOURCE_OF_TRUTH_LIVES}}

Derived from it (do not edit directly): {{DERIVED_OR_GENERATED_STYLE_ARTIFACTS}}

## Tokens

| Category | Defined in | Referenced as |
|---|---|---|
| Colors | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Typography | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Spacing | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Radius | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Shadows | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Breakpoints | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Motion | `{{PATH}}` | {{USAGE_EXAMPLE}} |
| Z-index | `{{PATH}}` | {{USAGE_EXAMPLE}} |

<!-- INSTALLER: Remove categories the project does not define. -->

Naming convention: {{TOKEN_NAMING_CONVENTION}}

Theming: {{HOW_THEMES_OR_DARK_MODE_WORK}}

## Components

- Shared components: `{{SHARED_COMPONENTS_LOCATION}}`
- Underlying library: {{COMPONENT_LIBRARY_IF_ANY_AND_HOW_IT_IS_WRAPPED}}
- Catalogue: {{STORYBOOK_OR_DOCS_LOCATION_AND_COMMAND}}
- Adding or extending a component: {{WHERE_IT_GOES_AND_WHAT_IT_MUST_INCLUDE}}

## Patterns

| Pattern | Reference implementation |
|---|---|
| {{PATTERN_FOR_EXAMPLE_FORM_TABLE_MODAL_EMPTY_STATE}} | `{{PATH}}` |

## Icons and assets

{{ICON_SET_USAGE_AND_ASSET_LOCATIONS}}

## Known inconsistencies

{{LEGACY_STYLES_OR_SCREENS_AND_WHICH_APPROACH_NEW_WORK_SHOULD_FOLLOW}}
