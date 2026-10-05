# Scenario: TypeScript Web App (Next.js + React)

Shows how the custom-ai-workflow skill adapts for a TypeScript web application.

## Discovery Input

The skill runs discovery commands and finds:

```
Repository Structure:
package.json
├── react ^18.2.0
├── next ^14.0.0
├── typescript ^5.3.0
├── jest ^29.0.0
├── vitest ^0.34.0
├── eslint v8.0.0
├── prettier v3.0.0
└── tailwindcss v3.3.0

next.config.js                    ← Next.js configured

src/
  app/                            ← App Router
    layout.tsx
    page.tsx
    [...routes]
  components/
    Button.tsx
    Button.test.tsx               ← Colocated tests
  lib/
    utils.ts
  services/
    api.ts

__tests__/                        ← Integration tests (Vitest)

.github/workflows/
  test.yml                        ← Runs Jest + Vitest
  build.yml
  deploy.yml                      ← Deploys to Vercel

tailwind.config.ts                ← Design tokens
tsconfig.json (strict: true)
.eslintrc.json
.prettierrc

Git:
  main branch (protected, requires review)
  Conventional Commits used
  Last 20 commits all "feat:" or "fix:" prefixed
```

## Analysis Output

```javascript
{
  "projectType": "Web App",
  "language": {
    "primary": "TypeScript",
    "secondary": ["CSS", "JSX/TSX"]
  },
  "framework": "Next.js 14",
  "routing": "App Router",
  "packageManager": "npm",
  "buildTool": "Turbopack",
  "testing": {
    "primary": "Jest",
    "secondary": ["Vitest"],
    "organization": "colocated",
    "coverage": 70
  },
  "linting": ["ESLint v8", "Prettier v3"],
  "styling": "Tailwind CSS",
  "deployment": "Vercel",
  "ci": "GitHub Actions",
  "maturity": "established",
  "teamSize": "small",
  "designSystem": {
    "tokens": "tailwind.config.ts",
    "components": "custom",
    "theming": "light-dark"
  },
  "concerns": {
    "authentication": false,
    "payments": false,
    "pii": false,
    "realtime": false,
    "accessibility": true,
    "performance": true
  }
}
```

## Questions Asked

```
🤔 Testing Framework Ambiguity
I found both Jest and Vitest configured. Which is primary?

A) Jest (jest.config.js is main, vitest is for integration)
   → New unit tests use Jest
   → Integration tests use Vitest
B) Vitest (faster, modern)
   → All tests consolidate to Vitest
C) [Tell me your preference]

User selects: A
```

```
🤔 Code Review Requirements
What's required for L2+ changes?

A) All changes require review from tech lead
B) Peer review (any team member)
C) Self-review only

User selects: B
```

```
🤔 Design Token Usage
How are tokens consumed?

A) CSS classes (Tailwind utility classes)
B) CSS variables (from tailwind.config.ts)
C) Both

User selects: A
```

## Generated Files

### `.ai/SKILL.md` (excerpt)

```markdown
# My Web App AI Workflow

v0.1 · customized 2026-10-05

> AI should adapt to the repository. The repository should not adapt to the AI.

## Stack

- **Framework**: Next.js 14 with React 18
- **Language**: TypeScript (strict mode)
- **Build**: Turbopack
- **Testing**: Jest (primary) + Vitest (integration)
- **Styling**: Tailwind CSS with light/dark themes
- **Deployment**: Vercel

## Quick Commands

```bash
npm test              # Jest watch mode
npm run test:vitest   # Vitest integration tests
npm run lint --fix    # ESLint + Prettier auto-fix
npm run build         # Turbopack build
npm run dev           # Dev server (localhost:3000)
```

## Workflows

- **Feature**: `rules/feature.md` + `rules/design-system.md`
- **Bug Fix**: `rules/bugfix.md` + `rules/debugging.md`
- **Refactor**: `rules/architecture.md`
- **UI Change**: `rules/design-system.md` + design tokens

## Always Load

- `rules/engineering.md` — TypeScript conventions
- `rules/architecture.md` — Next.js patterns
- `rules/testing.md` — Jest/Vitest approach
- `rules/design-system.md` — Tailwind + theming
```

### `rules/testing.md` (excerpt)

```markdown
# Testing Standards

## Framework Setup

**Primary**: Jest (jest.config.js)
- Unit tests for components, utilities, hooks
- Located colocated: `Button.test.tsx` next to `Button.tsx`

**Secondary**: Vitest (vitest.config.ts)
- Integration tests across components
- Located in `__tests__/integration/`
- Faster than Jest for full-app tests

## Test Files

```
src/
  components/
    Button/
      Button.tsx
      Button.test.tsx       ← Jest unit test
  lib/
    utils.test.ts          ← Jest unit test

__tests__/
  integration/
    auth-flow.test.ts      ← Vitest integration
    dashboard.test.ts      ← Vitest integration
```

## Running Tests

```bash
npm test              # Jest watch mode
npm run test:all      # Both frameworks
npm run test:vitest   # Vitest only
npm run test:coverage # Coverage report
```

## Coverage Targets

- Utilities: 100% (pure functions)
- Components: 70%+ (UI is harder to test)
- Pages: 30%+ (mostly integration tests)

## Ceremony by Level

- **L0**: No test
- **L1**: Manual test in browser
- **L2**: Add Jest unit test for logic
- **L3**: Add Vitest integration test for user flow
- **L4**: E2E test + full coverage
```

### `rules/design-system.md` (excerpt)

```markdown
# Design System

## Tokens (Tailwind CSS)

Located in `tailwind.config.ts`:

```javascript
theme: {
  colors: {
    primary: '#0066cc',
    secondary: '#6b7280',
    success: '#10b981',
    error: '#ef4444'
  },
  spacing: {
    4: '1rem',
    8: '2rem',
    12: '3rem'
  },
  fontSize: {
    sm: '0.875rem',
    base: '1rem',
    lg: '1.125rem'
  }
}
```

## Using Tokens

Always use Tailwind classes (never hardcode colors):

```jsx
// ✅ Good: uses token via Tailwind class
<button className="bg-primary text-white px-4 py-2">
  Click me
</button>

// ❌ Bad: hardcoded color
<button style={{ backgroundColor: '#0066cc' }}>
  Click me
</button>
```

## Light/Dark Theming

Tailwind handles light/dark automatically:

```jsx
<div className="bg-white dark:bg-gray-900 text-black dark:text-white">
  This adapts to theme
</div>
```

Enable dark mode in `tailwind.config.ts`:

```javascript
darkMode: 'class'
```

Theme is toggled via `<html class="dark">` (managed by app)

## Components

Shared components in `src/components/`:

- Button, Input, Dialog (custom)
- All accept `className` for extensions
- Composable: `<Button><Icon /> Label</Button>`

See `src/components/` for documentation.

## Accessibility

WCAG 2.1 AA required:

- All buttons have accessible labels: `aria-label` or label text
- Form inputs have `<label>`
- Color is not the only indicator (use icons/text too)
- Keyboard navigation works (Tab key)

Test with:
```bash
npm run test:a11y
```
```

## Generated `.ai/agents.md` (excerpt)

```markdown
# Agent Roles for My Web App

## Planner (for L2+ features)

Responsibilities:
- Analyze impact on Next.js/React code
- Check for new components vs existing (DRY)
- Plan test coverage (Jest unit + Vitest integration)
- Identify design token changes (if UI)
- Check TypeScript types

Plan template:
```
Feature: [Name]
Affected components: [list]
New components: [list]
Test plan: [unit/integration/E2E]
Design changes: [token/component changes]
Verification: [how to test]
```

## Investigator (for bugs)

Responsibilities:
- Reproduce in browser + check console
- Review Jest tests for the component
- Check TypeScript errors
- Verify with `npm run build`
- Check Vercel deployment logs

## Reviewer (required for all L2+ changes)

Checklist:
- [ ] `npm run lint` passes
- [ ] `npm run type-check` passes (TypeScript strict)
- [ ] `npm test` passes
- [ ] Component reuses existing components (no duplication)
- [ ] Design tokens used (no hardcoded colors/sizes)
- [ ] Accessible: labels, keyboard nav, color not only indicator
- [ ] Tests cover happy path + edge cases
```

## Questions Answered

`.ai/questions-answered.md`:

```markdown
# Adoption Decisions for My Web App

Generated: 2026-10-05

## Testing
- **Primary Framework**: Jest (Q1: Candidate A)
- **Secondary**: Vitest for integration
- **Organization**: Colocated unit tests
- **Coverage Target**: 70% for new code

## Architecture
- **Planning Ceremony**: L2+ only (no plan for L0-L1)
- **Component Reuse**: Always check existing components first
- **Design Tokens**: Use Tailwind classes, never hardcode

## Code Review
- **Requirement**: Peer review for L2+ (not just tech lead)
- **Authority**: Any team member can approve

## Design
- **Tokens**: Tailwind utility classes
- **Theming**: Light/dark via Tailwind dark: prefix
- **Accessibility**: WCAG 2.1 AA required

---

These answers are locked in. Edit them if project needs change.
```

## Generated Commit Message

```
adopt: initialize AI workflow for My Web App

Discovered:
- Next.js 14 web app with React 18
- TypeScript strict mode
- Jest (unit) + Vitest (integration) testing
- Tailwind CSS with light/dark themes
- Deployed to Vercel
- GitHub Actions CI

Generated:
- .ai/SKILL.md — TypeScript/React-specific guidance
- .ai/AGENTS.md — planner, investigator, reviewer roles
- rules/engineering.md — TypeScript conventions
- rules/testing.md — Jest + Vitest ceremony levels
- rules/design-system.md — Tailwind + accessibility
- references/task-complexity.md — web app examples

Assumptions (changeable):
- Jest primary (Vitest secondary for integration)
- Peer review required L2+ (candidate A)
- Tailwind classes for tokens (candidate A)
- L2+ requires planning, L0-L1 do not
- Component reuse is priority

To update: Edit .ai/questions-answered.md or run /custom-ai-workflow --force

Co-Authored-By: custom-ai-workflow skill <noreply@anthropic.com>
```

---

## Example Agent Interaction

### Agent receives task: "Add a login form"

1. **Discover** (from SKILL.md):
   - `npm test` runs Jest
   - `npm run build` uses Turbopack
   - Components in `src/components/`
   - Tailwind tokens in `tailwind.config.ts`

2. **Understand**:
   - Look at existing forms (`Input.tsx`, `Button.tsx`)
   - Check auth state management (useState, context, etc.)
   - Review existing login tests (if any)

3. **Classify**: L3 (new feature, crossing multiple components)

4. **Plan** (follows template from AGENTS.md):
   ```
   Feature: Login Form
   Affected: Input, Button, AuthContext
   New: LoginForm component
   Test: Unit test for form + integration test for flow
   Design: Using existing tokens (primary button, neutral input)
   Verify: npm test && npm run build
   ```

5. **Implement**:
   - Create `src/components/LoginForm/LoginForm.tsx`
   - Create `src/components/LoginForm/LoginForm.test.tsx` (Jest)
   - Add integration test in `__tests__/integration/auth.test.ts` (Vitest)
   - Use Tailwind classes for styling
   - Follow TypeScript strict mode

6. **Verify**:
   ```bash
   npm run lint --fix
   npm run type-check
   npm test
   npm run test:vitest
   npm run build
   ```

7. **Review** (peer):
   - Check style, types, tests
   - Verify tokens used, not hardcoded colors
   - Verify accessibility (labels, keyboard nav)
   - Approve and merge

---

This is how the skill adapts: discovers your exact stack, asks about your preferences, then generates guidance that's specific to TypeScript + React + Next.js + Tailwind + your team's decisions.
