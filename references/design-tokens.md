# Reference: Design Tokens

Load only when the repository contains UI code. Companion to `rules/design-system.md`.

A design token is a named design decision. Projects store them in many forms. Find the form this project uses and work with it. Never require or generate a `tokens.json`, and never convert a project's tokens to another format as part of setup.

## Where tokens live

| Form | Evidence |
|---|---|
| CSS custom properties | `:root { --color-... }` in global stylesheets, theme files, `[data-theme]` blocks |
| Tailwind theme | `tailwind.config.*` `theme` and `extend`, or `@theme` blocks in CSS |
| JS or TS theme objects | `theme.ts`, `tokens.ts`, styled-components or Emotion theme providers, vanilla-extract contracts |
| Sass or Less variables | `_variables.scss`, `_tokens.scss`, maps and mixins |
| Component-library themes | MUI `createTheme`, Chakra `extendTheme`, Ant Design tokens, shadcn `components.json` plus CSS variables |
| Flutter | `ThemeData`, `ColorScheme`, `TextTheme`, theme extensions |
| Swift | Color and font extensions, asset catalogs, design-system packages |
| Android | `res/values/colors.xml`, `dimens.xml`, `themes.xml`, Compose `MaterialTheme` |
| Dedicated token systems | Style Dictionary sources, Tokens Studio exports, a shared tokens package |

A project may layer several of these, for example a token package that feeds a Tailwind theme. Identify which one is the source of truth and which are derived, and send agents to the source.

## What to inventory

Check each category and record where it is defined and how it is referenced in code. Skip categories the project does not define.

- Colors, including semantic roles and theme variants
- Typography: families, sizes, weights, line heights, text styles
- Spacing scale
- Radius
- Shadows and elevation
- Breakpoints
- Motion: durations and easings
- Z-index layers

Also locate shared components, the icon set, and one or two screens that best represent the current visual language.

## Decision guide

| Situation | What to do |
|---|---|
| A formal design system exists | Use it. Document where it lives and how to consume it. |
| Tokens exist without a wider system | Use them. Document their location and naming. |
| No formal tokens, but screens are consistent | Document the de facto values and components as observed patterns, and tell agents to match existing screens. Do not formalize them into a new token file. |
| The UI is inconsistent | Identify the newest or dominant pattern, tell agents to follow it, and note the inconsistency. Do not pick a winner by rewriting. |
| No UI | Do not load this reference or generate design-system artifacts. |

## What to write into the project

Record locations, the source of truth, naming conventions, and how values are referenced. Do not copy the token values into `.agent/`; a copy goes stale the first time a color changes.
