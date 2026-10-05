# Rule: Design System

Load only when the repository contains UI code.

> Reuse the existing visual language before extending it. Extend it before creating a competing system.

## Order of preference

1. **Reuse** an existing component, token, or page pattern as it is.
2. **Compose** existing components to build the new thing.
3. **Extend** an existing component or token set, in the place and style the project already uses.
4. **Create** something new only when the first three cannot work, and build it from existing tokens.

## Requirements

- Find the design system before writing UI: tokens, theme, shared components, and a comparable existing screen. `references/design-tokens.md` lists where tokens live.
- Use tokens for color, type, spacing, radius, shadow, breakpoints, motion, and z-index. No hard-coded values where a token exists.
- Match existing patterns for layout, forms, feedback states, empty states, loading, and errors.
- Use the project's icon set, and its existing approach to dark mode, responsiveness, and accessibility.
- Do not add a UI library, CSS framework, or icon package that competes with what is installed.

## When there is no formal system

Most projects still have a de facto visual language. Read existing screens, find the values and components used most consistently, and follow them. Do not invent a token system or component library as a side effect of a feature. If consolidating is worthwhile, propose it as its own task.

## Verification

Look at the result, in the states and sizes the project supports, next to an existing screen. If you cannot render it, say so.
