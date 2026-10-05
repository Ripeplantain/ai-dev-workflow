# Step 4: Generate Customized Files

Use discoveries, analysis, and answered questions to generate a complete AI workflow setup customized to this repository.

## Generation Strategy

Instead of copying fixed templates, **parametrize templates** with discovered values:

```
Base Templates + Discoveries + Questions → Customized Files
```

**Template format:**
```
[PLACEHOLDER]           → filled from discoveries
[CONDITIONAL: signal]   → included only if condition is true
[LANGUAGE:go]           → language-specific variant
```

**Example:**
```markdown
## Testing Strategy

This [PROJECT_TYPE] uses [PRIMARY_TEST_FRAMEWORK]:

- Tests located: [TEST_LOCATION]
- Coverage target: [COVERAGE_TARGET]
- Ceremony: [TESTING_CEREMONY]
```

Becomes:

```markdown
## Testing Strategy

This API uses Jest and Vitest:

- Tests located: `__tests__/` colocated with source
- Coverage target: 70%+ for new code
- Ceremony: L0-L1 self-review, L2+ peer review
```

---

## File Generation Sequence

### Step 4.1: Generate `.agent/PROJECT.md`

**Input:**
- discoveries.md output
- analysis report
- questions answered

**Template:** `templates/project.template.md`

**Customizations:**
- Replace `[PROJECT_NAME]`, `[PROJECT_TYPE]`, `[PRIMARY_LANGUAGE]`
- Inject discovered workflows (feature, bugfix, migration applicable?)
- Populate examples with actual repository commands
- Reference discovered tools (Jest, Vitest, eslint, prettier, etc.)
- Include special concerns (auth, payments, real-time)
- Reference `.agent/` structure

**Output:** `.agent/PROJECT.md` (2-4 KB, project context guide)

Example sections:

```markdown
# [Project Name] — Agent Context

Updated: [DATE]

> AI should adapt to the repository. The repository should not adapt to the AI.

## Project Overview

[Project type, stack, and key characteristics]

## Workflows

[Conditionally include workflows relevant to this project]

- **Feature development**: `.agent/workflows/feature.md`
- **Bug fixes**: `.agent/workflows/bugfix.md`
[Skip migration.md if single project, skip ui-feature.md if not UI]

## Commands

**Testing:** `npm test` (Jest) or `npm run test:watch` (Vitest)
**Linting:** `npm run lint` (eslint + prettier)
**Building:** `npm run build` (Turbopack)
[Language-specific commands based on discoveries]
```

### Step 4.2: Generate `.agent/AGENTS.md`

**Input:**
- discoveries (team size, maturity)
- analysis (project type, complexity)
- questions (planning ceremony, review authority)

**Template:** `templates/agents.template.md`

**Customizations:**
- Include only relevant roles (skip tester if testing is integrated)
- Populate examples from actual project concerns
- Reference responsibilities that fit this project type
- Include team-specific decisions (who approves what)

**Output:** `.agent/AGENTS.md` (1-2 KB)

Example:

```markdown
# [Project Name] Agent Roles

## Planner

**When to use:** L2+ features, cross-package changes, migrations

**Responsibilities:**
- Analyze impact on [LANGUAGE]/[FRAMEWORK] code
- Check for database changes (see `rules/database.md`)
- Plan for testing: unit + integration (per `rules/testing.md`)
- Identify affected packages: [PACKAGES] (see `rules/monorepo.md`)

**Success:** Plan is < 500 words, names affected files, lists verification steps

**Approval:** [CODE_REVIEW_AUTHORITY]

## Investigator

**When to use:** Bug reports, performance issues, mysterious failures

**Responsibilities:**
- Run discovery commands (see `references/repository-discovery.md`)
- Check [TESTING_FRAMEWORK] tests for edge cases
- Review [LANGUAGE] error patterns
- Verify with [DEPLOYMENT_PLATFORM] logs

## Reviewer

**When to use:** All [CODE_REVIEW_REQUIREMENT] changes

**Responsibilities:**
- Check against `rules/architecture.md`
- Verify tests pass: `npm test`
- Check for [LANGUAGE] type safety issues
- Review for [SPECIAL_CONCERNS]: [list from discoveries]
```

### Step 4.3: Generate `rules/` Files

Create customized versions of base rules:

#### `rules/engineering.md`

Template: `templates/rules/engineering.template.md`

Customize for:
- **Language conventions**: How does this language name things? (camelCase, snake_case, etc.)
- **Code style**: What does the linter enforce? (eslint rules, prettier config)
- **Import organization**: How are imports organized? (barrel exports? relative paths?)
- **Tooling**: What's actually used? (eslint v8.0+, prettier v3.0+)
- **Git integration**: Pre-commit hooks? (husky, lint-staged, etc.)

Output example:

```markdown
# Engineering Standards

## TypeScript Conventions

This project uses TypeScript with strict mode enabled.

- **Type annotations**: Explicit for all function params and returns
- **Naming**: camelCase for variables, PascalCase for types/components
- **Imports**: Absolute paths via tsconfig baseUrl
- **Barrel exports**: Use `index.ts` to export public API

Enforced by:
- `npm run lint` (ESLint v8.x)
- `npm run format` (Prettier v3.x)
- `tsconfig.json` (strict: true)

## Code Style

Run on save or before commit:

```bash
npm run lint --fix
npm run format --write
```

[Language-specific details based on detected linter rules]
```

#### `rules/testing.md`

Template: `templates/rules/testing.template.md`

Customize for:
- **Primary framework**: Jest? Vitest? pytest?
- **Organization**: Colocated (`*.test.ts`) or separate (`__tests__/`)?
- **Approach**: Unit? Integration? Both?
- **Coverage**: What's the target?
- **Ceremony levels**: What does each L0-L4 task require?

Output example:

```markdown
# Testing Standards

## Framework

Primary: Jest (jest.config.js)
Secondary: Vitest for integration tests

```bash
npm test              # Jest watch mode
npm run test:vitest   # Vitest integration tests
npm run test:all      # Both frameworks
```

## File Organization

```
src/
  components/
    Button/
      Button.tsx
      Button.test.tsx      ← Colocated unit test
      Button.int.test.tsx  ← Colocated integration test
```

## Ceremony by Level

- **L0**: No test required (typo, formatting)
- **L1**: Self-review pass (unit test if behavior changes)
- **L2**: Unit + integration, 70%+ coverage
- **L3**: Add E2E test if user-facing
- **L4**: Full coverage, documented edge cases

## Running Tests

```bash
npm test                    # Jest
npm run test:vitest         # Vitest
npm run test:coverage       # Coverage report
```
```

#### `rules/architecture.md`

Template: `templates/rules/architecture.template.md`

Customize for:
- **Project type**: Web app? API? Library?
- **Directory structure**: Show actual structure
- **Monorepo layout**: If present, show boundaries
- **Dependency direction**: What depends on what?
- **Patterns**: Feature-based? Layer-based?
- **Constraints**: Hard rules vs soft guidelines

Output example:

```markdown
# Architecture Patterns

## Project Type: [TYPE]

[TYPE-specific guidance]

## Directory Structure

```
src/
  components/           ← Shared UI components
  features/             ← Feature modules
    auth/
      components/
      hooks/
      services/
      auth.test.ts
    dashboard/
      ...
  lib/                  ← Utilities and helpers
  services/             ← External integrations
```

## Feature Bundle Format

Each feature in `features/` follows:

```
feature-name/
  components/           ← Feature-specific components
  hooks/                ← Custom hooks
  services/             ← API calls or business logic
  types/                ← TypeScript types
  feature-name.test.ts  ← Tests
```

## Dependency Rules

- ✅ Components import from lib/
- ✅ Services call external APIs
- ❌ Features should NOT import from other features
- ❌ Features should NOT depend on pages/

[If monorepo]
## Monorepo Boundaries

Packages:
- `packages/ui` — Shared components (depended on by all)
- `packages/core` — Business logic
- `apps/web` — Frontend (depends on ui + core)
- `apps/api` — Backend

Hard constraint: No circular dependencies
```

#### `rules/git.md`

Template: `templates/rules/git.template.md`

Customize for:
- **Branch strategy**: Trunk-based? Feature branches?
- **Commit messages**: Conventional commits format?
- **Code review**: Required? Optional?
- **Merge strategy**: Squash? Rebase?

Output example:

```markdown
# Git Workflow

## Branches

- `main` — production-ready code, protected, requires review
- `develop` — integration branch (optional, detected in your repo)
- Feature branches: `feature/description` from develop

## Commits

Follow Conventional Commits format:

```
feat: add login page
fix: handle token refresh edge case
docs: update README
refactor: extract Button component
test: add coverage for auth
chore: bump dependencies
```

## Pull Requests

- Require 1 review before merge
- Run CI checks: `npm test`, `npm run lint`, `npm run build`
- Squash before merge for clean history

## Merging

```bash
git switch main
git pull origin main
git switch feature/my-change
git rebase main
git switch main
git merge --squash feature/my-change
git commit -m "feat: my change (#123)"
git push origin main
```
```

#### `rules/design-system.md` (if UI project)

Template: `templates/rules/design-system.template.md`

Customize for:
- **Tokens format**: CSS vars? Tailwind? Theme object?
- **Component library**: shadcn? Custom?
- **Theming strategy**: Light/dark? Multiple?
- **Accessibility**: Required standard?

Output example:

```markdown
# Design System

## Tokens

Located in `tailwind.config.ts`:

```javascript
colors: {
  primary: '#0066cc',
  neutral: { 50: '#f9f9f9', ... }
}
spacing: {
  0: '0', 4: '0.25rem', 8: '0.5rem', ...
}
```

Use via Tailwind classes:

```jsx
<button className="bg-primary text-white px-4 py-2">
```

## Components

Shared components in `packages/ui` (shadcn/ui + custom):

- Button, Input, Dialog (from shadcn)
- Card, Banner (custom)

```bash
npx shadcn-ui add button
```

## Theming

Light and dark modes via CSS class:

```html
<html class="dark">
```

Tokens automatically adapt via Tailwind `dark:` prefix.

## Accessibility

WCAG 2.1 AA required:
- Keyboard navigation
- Color contrast (4.5:1 for text)
- ARIA labels
- Screen reader testing

```bash
npm run a11y:test
```
```

#### `rules/security.md` (if special concerns detected)

Template: `templates/rules/security.template.md`

Customize for:
- **Authentication**: JWT? NextAuth? Clerk?
- **Payments**: Stripe? Handling?
- **PII**: Data retention? Encryption?
- **Secrets**: Environment variables? Vault?

Output example:

```markdown
# Security Guidelines

## Authentication

NextAuth.js handles auth:

- JWT-based sessions
- Database stores refresh tokens
- Token rotation every 7 days

When adding auth features:
- Never store passwords
- Always use HTTPS
- Validate tokens server-side

## Payments

Stripe integration for subscriptions:

- Webhook signatures verified in `api/webhooks/stripe.ts`
- Idempotency keys prevent duplicate charges
- PCI-DSS: No raw card data in logs

When handling payments:
- Use Stripe Elements (never raw credit cards)
- Verify webhook signatures
- Log transaction IDs, not amounts

## Environment Secrets

Stored in `.env.local` (never committed):

```
NEXTAUTH_SECRET=...
STRIPE_SECRET_KEY=...
DATABASE_URL=...
```

Reference in code: `process.env.SECRET_NAME`

Never log secrets. Use `console.log(secret.slice(0, 4))` for debugging.

## PII Handling

User data (emails, names, addresses):
- Encrypted at rest in database
- Never logged
- Deleted after 30 days of account deletion
- GDPR-compliant queries in `lib/gdpr.ts`
```

### Step 4.4: Generate `references/` Files

#### `references/repository-discovery.md`

Template: `templates/references/repository-discovery.template.md`

Output: Results from discover.md

```markdown
# Repository Discovery

Generated: 2026-10-05

## Stack

- Language: [PRIMARY_LANGUAGE]
- Framework: [FRAMEWORK]
- Package Manager: [PACKAGE_MANAGER]
- Build: [BUILD_TOOL]
- Testing: [TEST_FRAMEWORKS]
- Linting: [LINTERS]
- Deployment: [DEPLOYMENT]

## Tooling

```bash
npm test              # Run tests
npm run lint          # Run linter
npm run build         # Build project
npm run dev           # Dev server
[Any other scripts]
```

## Key Files

- `package.json` — Dependencies and scripts
- `tsconfig.json` — TypeScript configuration
- `.eslintrc.json` — Linting rules
- `.prettierrc` — Formatting rules
- `jest.config.js` — Testing configuration
[Other important files specific to project]
```

#### `references/task-complexity.md`

Template: `templates/references/task-complexity.template.md`

Output: Customized complexity levels with examples relevant to this project

```markdown
# Task Complexity Levels

## L0: Trivial

Examples:
- Fix typos in README
- Update version number
- Reformat a file

Ceremony:
- Skip planning
- Implement directly
- No review needed

## L1: Simple

Examples:
- Update a single component style
- Add console log for debugging
- Fix a missing import

Ceremony:
- No planning needed
- Self-review (does it work?)
- No peer review required

## L2: Moderate

Examples:
- Add a new Jest test case
- Refactor a utility function
- Update error message

Ceremony:
- Optional planning
- Write tests
- Code review required
- Verify: `npm test && npm run lint`

## L3: Substantial

Examples:
- Add new feature (login flow, dashboard page)
- Migrate API endpoint
- Update database schema

Ceremony:
- Planning required (1-2 page design doc)
- Comprehensive tests (unit + integration)
- 2 code reviewers
- Verify: full test suite + build
- Consider: performance, security implications

## L4: Critical

Examples:
- Architecture change (monorepo restructure)
- Authentication overhaul
- Payment processing changes

Ceremony:
- Extensive planning (ADR, stakeholder review)
- Full test coverage
- Security review (if applicable)
- Performance testing
- Staged rollout
- Post-deployment monitoring
```

#### `references/definition-of-done.md`

Template: `templates/references/definition-of-done.template.md`

Customize based on:
- Task complexity level
- Special concerns (security, performance)
- Team expectations

Output example:

```markdown
# Definition of Done

A change is ready to merge when:

## Code Quality (All Levels)

- [ ] Code matches `rules/engineering.md` style
- [ ] No linting errors: `npm run lint`
- [ ] No formatting issues: `npm run format --check`
- [ ] Type-safe (TypeScript strict mode)

## Testing

- [ ] L0-L1: Manual verification in browser/CLI
- [ ] L2+: Unit tests written and passing
- [ ] L3+: Integration tests added
- [ ] L4: E2E tests + coverage > 90%

Run: `npm test && npm run test:coverage`

## Documentation

- [ ] Code comments added (complex logic only)
- [ ] Function/component JSDoc present
- [ ] README updated if user-facing
- [ ] ADR created (if architectural decision)

## Verification

- [ ] Builds successfully: `npm run build`
- [ ] Dev server works: `npm run dev`
- [ ] Tests pass locally
- [ ] Tested in [DEPLOYMENT_PLATFORM] preview

## Review

- [ ] Code review passed (see `AGENTS.md`)
- [ ] Security review (if auth/payments/PII involved)
- [ ] Performance review (if critical path)

## Git

- [ ] Commits follow Conventional Commits
- [ ] Branch rebased on main
- [ ] PR linked to issue (if applicable)
```

---

## Generation Execution

Run in order:

1. **Validate** template files exist
2. **Load** discoveries, analysis, questions-answered
3. **For each file** (skill.md, agents.md, engineering.md, ...):
   - Read template
   - Replace all `[PLACEHOLDERS]` with discovered values
   - Include/exclude `[CONDITIONAL: signal]` sections
   - Select `[LANGUAGE:go]` or `[LANGUAGE:typescript]` variants
   - Write output
4. **Validate** all generated files:
   - No unreplaced placeholders
   - All file references are relative and correct
   - Markdown syntax is valid
5. **Create** `.agent/decisions.md` summary
6. **Create** commit message with assumptions listed
7. **Ask** for final approval before committing

---

## Validation Checklist

Before committing, verify:

- [ ] All `.agent/` and `rules/` and `references/` files created
- [ ] No `[PLACEHOLDER]` remains unreplaced
- [ ] All internal links (`rules/testing.md`) resolve
- [ ] File references match actual scripts in `package.json`
- [ ] Language-specific sections (TypeScript, Go, Python) match detected languages
- [ ] Questions answered are reflected in generated files
- [ ] `.agent/decisions.md` documents all decisions
- [ ] Commit message lists discovered facts and assumptions

---

## Commit Example

```
adopt: initialize AI workflow for [Project Name]

Discovered:
- TypeScript + React web app (Next.js 14)
- Jest (unit) + Vitest (integration) testing
- Monorepo with pnpm workspaces (apps/web, apps/api, packages/ui)
- Turborepo for builds
- Deployed to Vercel

Generated:
- .agent/PROJECT.md — project context and workflows
- .agent/AGENTS.md — roles for planner, investigator, reviewer
- .agent/context/ — architecture and design decisions
- rules/ — customized to TypeScript + React + testing approach
- references/ — discovery data and task complexity levels

Assumptions (changeable via .agent/decisions.md):
- Jest is primary test framework (Vitest for integration)
- All changes L2+ require code review
- Monorepo boundaries are hard constraints
- Conventional Commits format for all messages
- Code review by tech lead (see .agent/AGENTS.md)

To modify: Update .agent/decisions.md and re-run with --force

Co-Authored-By: custom-ai-workflow skill <noreply@anthropic.com>
```
