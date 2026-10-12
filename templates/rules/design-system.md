<!-- INSTALLER: Source for .agent/rules/design-system.md. Write only when the project has UI code.

Find the token source of truth before filling this in. Tokens take many forms: CSS custom properties (`:root { --color-… }`, `[data-theme]` blocks), a Tailwind theme (`tailwind.config.*` or `@theme` in CSS), JS/TS theme objects (`theme.ts`, styled-components or Emotion providers, vanilla-extract contracts), Sass variables (`_variables.scss`), component-library themes (MUI `createTheme`, Chakra `extendTheme`, shadcn `components.json` plus CSS variables), Flutter `ThemeData`, Android `res/values/*.xml`, or a dedicated tokens package. A project may layer several — a tokens package feeding a Tailwind theme — so identify which is the source and which is derived, and send agents to the source.

Record locations and naming, never the values: a copy of the palette goes stale the first time a color changes. Never require or generate a tokens.json, and never convert the project's tokens to another format as part of setup. If there are no formal tokens, say so and name the screens and components that define the de facto style. Delete every INSTALLER note. -->

# Design system

> Reuse the existing visual language before extending it. Extend it before creating a competing system.

## Where the visual language lives

- Tokens and theme: `{{TOKEN_SOURCE_OF_TRUTH}}`, referenced as {{HOW_TOKENS_ARE_REFERENCED_IN_CODE}}
- Derived from the above, do not edit directly: {{DERIVED_THEME_FILES_IF_ANY}}
- Shared components: `{{SHARED_COMPONENTS_LOCATION}}`
- Icons: {{ICON_SET_AND_USAGE}}
- Reference screens: `{{ONE_OR_TWO_REPRESENTATIVE_SCREENS}}`

## Order of preference

1. Reuse an existing component or token as it is.
2. Compose existing components.
3. Extend an existing component or the token set, in `{{WHERE_EXTENSIONS_GO}}`.
4. Create something new only when the first three cannot work, built from existing tokens.

Justify every "new" component. The default answer is reuse.

## Requirements

- No hard-coded colors, sizes, spacing, radii, shadows, or breakpoints where a token exists.
- Styling approach: {{STYLING_APPROACH_AND_CONVENTIONS}}. Do not mix in another.
- Match existing patterns for layout, forms, feedback, and empty states.
- Every new screen handles {{STATES_THE_PROJECT_HANDLES_FOR_EXAMPLE_LOADING_EMPTY_ERROR}}.
- {{DARK_MODE_RESPONSIVE_AND_ACCESSIBILITY_EXPECTATIONS}}
- Do not add a UI library, CSS framework, or icon package that competes with what is installed.

<!-- INSTALLER: If the UI is inconsistent, name the newest or dominant pattern as the one to follow and note the inconsistency. Do not pick a winner by rewriting. -->

## Verification

Render the result and compare it with a reference screen across {{SUPPORTED_VIEWPORTS_AND_THEMES}}. {{UI_TEST_OR_STORYBOOK_COMMAND}} If you cannot render the UI in this environment, say so plainly rather than claiming it looks right.
