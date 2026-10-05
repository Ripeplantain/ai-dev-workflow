<!-- INSTALLER: Source for .agent/rules/design-system.md. Generate only when the project has UI code. If context/design-system.md is also generated, keep locations there and reference it from here; otherwise put the locations in this file. Delete every INSTALLER note. -->

# Rule: Design System

> Reuse the existing visual language before extending it. Extend it before creating a competing system.

## Where the visual language lives

- Tokens and theme: `{{TOKEN_SOURCE_OF_TRUTH}}`, referenced as {{HOW_TOKENS_ARE_REFERENCED_IN_CODE}}
- Shared components: `{{SHARED_COMPONENTS_LOCATION}}`
- Icons: {{ICON_SET_AND_USAGE}}
- Reference screens: `{{ONE_OR_TWO_REPRESENTATIVE_SCREENS}}`

<!-- INSTALLER: If there are no formal tokens, say so and name the screens and components that define the de facto style. -->

## Order of preference

1. Reuse an existing component or token as it is.
2. Compose existing components.
3. Extend an existing component or the token set, in `{{WHERE_EXTENSIONS_GO}}`.
4. Create something new only when the first three cannot work, built from existing tokens.

## Requirements

- No hard-coded colors, sizes, spacing, radii, shadows, or breakpoints where a token exists.
- Styling approach: {{STYLING_APPROACH_AND_CONVENTIONS}}. Do not mix in another.
- Every new screen handles {{STATES_THE_PROJECT_HANDLES_FOR_EXAMPLE_LOADING_EMPTY_ERROR}}.
- {{DARK_MODE_RESPONSIVE_AND_ACCESSIBILITY_EXPECTATIONS}}
- Do not add a UI library, CSS framework, or icon package.

## Verification

Render the result and compare it with a reference screen across {{SUPPORTED_VIEWPORTS_AND_THEMES}}. {{UI_TEST_OR_STORYBOOK_COMMAND}}
