# Workflow: UI Feature

Additions for features with a user interface. Follow `workflows/feature.md` for the overall lifecycle and apply these at each phase. Governed by `rules/design-system.md`.

## Discover

- Find the most similar existing screen or component and treat it as the reference.
- Locate the design system: tokens, theme, shared components, icons (`references/design-tokens.md`).
- Collect what was specified: designs, copy, states, breakpoints. Note what was not specified.

## Understand

- List the components the feature needs and mark each one: reuse, compose, extend, or new.
- Note how the reference screen handles data loading, state, routing, forms, and errors.

## Plan

- Justify every "new" component. The default answer is reuse.
- List the states to build: loading, empty, error, success, disabled, and the responsive and theme variants the project supports.

## Implement

- Use tokens, never raw values where a token exists.
- Follow the project's component structure, styling approach, and naming.
- Meet the project's accessibility baseline: semantic elements, labels, keyboard operation, focus handling, contrast.
- Use the project's existing approach to copy and localization.

## Verify

- Render it and compare it side by side with the reference screen.
- Check each state and each supported viewport and theme.
- Run the project's UI tests, visual tests, and accessibility checks if they exist.
- If you cannot render the UI in this environment, say so plainly in the report.

## Review

Look for hard-coded values, duplicated components, a second way of doing something the project already does one way, and inconsistent spacing or type.

## Report

Include which components were reused, extended, or created, and which states and viewports were checked.
