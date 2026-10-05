# Custom AI Workflow Skill

Automatically adopt the Universal AI Engineering Skill into any repository by analyzing its conventions, generating contextual documentation, and asking clarifying questions when uncertain.

## Overview

This skill helps you establish a repeatable, repository-aware AI agent workflow by:

1. **Discovering** the repo's actual structure, tooling, conventions, and patterns
2. **Analyzing** project context (type, maturity, tech stack, team patterns)
3. **Generating** a custom AI workflow setup:
   - `SKILL.md` — root orchestrator with repo-specific guidance
   - `AGENTS.md` — agent roles suited to this project
   - `rules/` — engineering rules tailored to the tech stack and conventions
   - `references/` — discovery outputs and project context
4. **Asking questions** when uncertain (with candidate answers)
5. **Committing** generated files with documented assumptions

## When to use

- Setting up a new repository with AI agent support
- Migrating an existing project to use AI agents
- Documenting conventions that AI agents should follow
- Creating team-wide guidelines for how agents should work in your codebase

## What you provide

- Path to the repository (defaults to current directory)
- Optional template: `minimal`, `standard`, or `monorepo`
- Answers to clarifying questions when the skill detects ambiguity

## What gets generated

```
.ai/
├── SKILL.md                    # Root orchestrator with repo discoveries
├── AGENTS.md                   # Agent roles and contracts
rules/
├── engineering.md              # Custom to tech stack and conventions
├── architecture.md             # Custom to project structure
├── testing.md                  # Custom to testing approach
├── git.md                       # Custom to Git workflow
├── security.md                 # Custom to security concerns
├── repo-sanity.md              # Custom to repo patterns
└── design-system.md            # (if UI project)
references/
├── task-complexity.md          # Tailored complexity levels
├── repository-discovery.md     # Discovery outputs
└── definition-of-done.md       # Project-specific checklist
```

## Process

### 1. Discovery Phase

The skill analyzes:

**Tooling & Stack**
- Package managers (npm, yarn, pnpm, pip, cargo, go.mod)
- Build tools (webpack, vite, turbopack, esbuild)
- Testing frameworks (jest, vitest, pytest, rspec, etc.)
- Linting & formatting (eslint, prettier, black, clippy)
- CI/CD platforms (.github/workflows, .gitlab-ci.yml, vercel.json, cloudbuild.yaml)
- Version control (Git configuration, branch protection rules)

**Architecture Patterns**
- Monorepo structure (pnpm workspaces, Turborepo, Nx, lerna)
- Project type (web app, API, library, CLI, infrastructure)
- Directory structure (flat vs nested, feature-based vs layer-based)
- Shared code patterns (how utilities/components are reused)
- Dependency direction (any circular deps? clear ownership?)

**Conventions**
- Naming conventions (camelCase, snake_case, PascalCase)
- Code structure (where tests live, where configs go)
- Testing strategy (unit, integration, E2E, coverage targets)
- Git workflow (trunk-based, feature branches, commit message format)
- Code review process (required approvals, who reviews what)

**Existing Documentation**
- ARCHITECTURE.md, CONTRIBUTING.md, README.md patterns
- Existing .ai/ or .github/ guidance
- Team playbooks or runbooks
- Design system documentation (if present)

### 2. Analysis Phase

Categorize findings:

- **Project Type**: web app, API, library, CLI, monorepo, infrastructure
- **Tech Stack**: languages, frameworks, platforms, databases
- **Repo Maturity**: early, established, legacy, migrating
- **Team Context**: solo, small team, distributed, cross-org
- **Special Concerns**: payments, auth, PII, real-time, edge compute, accessibility
- **Design System** (if UI): tokens, components, patterns, theming approach

### 3. Question Phase

When the skill finds ambiguity, it asks with candidate options:

```
🤔 Testing Strategy
I found both Jest and Vitest configs. Which is canonical?

A) Jest (jest.config.js is primary)
B) Vitest (vitest.config.ts, faster feedback)
C) Both equally (tests should work in both)
D) Let me provide details
```

Questions cover:
- Testing approach and rigor
- Code review requirements
- When to plan vs when to implement
- Risk tolerance (how much verification is enough?)
- Design decisions (tokens format, monorepo boundaries)
- Team-specific concerns

### 4. Generation Phase

The skill generates custom rules and guidance using:

- **Base templates** from this repo's `templates/`
- **Discovered conventions** (what it saw in the codebase)
- **Answers to questions** (user preferences)
- **Project context** (type, maturity, stack)

Each generated file includes:
- Repository-specific examples
- Links to actual tools/commands found in the repo
- Callouts for areas that need manual review
- Assumptions documented at the top

### 5. Verification Phase

Before committing, the skill:

- Validates that generated files are syntactically correct Markdown
- Checks that all file references resolve
- Confirms that no existing SKILL.md would be overwritten (unless `--force`)
- Lists what will be committed

### 6. Commit Phase

Commits generated files with a message like:

```
adopt: add custom AI workflow to [Project Name]

Discovered:
- Tech stack: TypeScript, React, Jest, Vitest
- Testing approach: Jest for unit, Vitest for integration
- Monorepo: pnpm workspaces with 8 packages
- Architecture: feature-based structure
- Git workflow: trunk-based with required reviews

Generated:
- SKILL.md with repo-specific guidance
- AGENTS.md with 3 roles (planner, investigator, reviewer)
- rules/ tailored to TypeScript/React conventions
- references/ with discovery data

Assumptions:
- Featured Jest as primary (vitest as secondary)
- Code review required for critical paths
- Agent planning on cross-boundary changes only

Co-Authored-By: custom-ai-workflow skill <noreply@anthropic.com>
```

## Usage

```bash
# Analyze current repo, ask questions, generate files
/custom-ai-workflow

# Analyze a specific path
/custom-ai-workflow --path ./apps/web

# Use a template scaffold
/custom-ai-workflow --template standard

# Re-run (force overwrite) if you've updated conventions
/custom-ai-workflow --force

# Dry-run: show what would be generated without committing
/custom-ai-workflow --dry-run
```

## Example Outputs

See `examples/` for sample generated files for:
- TypeScript web app (React + Next.js)
- Python API (FastAPI + PostgreSQL)
- Monorepo (pnpm workspaces + Turborepo)
- Go microservice
- Rust CLI

## FAQ

**Q: Will this overwrite my existing SKILL.md?**  
A: No, it will refuse unless you pass `--force`. Review and merge instead.

**Q: What if the skill gets something wrong?**  
A: Review the generated files, edit them, then commit. The skill documents its assumptions so you know what to change.

**Q: Can I run this multiple times?**  
A: Yes. Re-run it after major refactors, tech stack changes, or team process updates. It will ask what changed.

**Q: Does this work with monorepos?**  
A: Yes. It detects workspace boundaries and can generate shared rules + per-workspace customizations.

**Q: What if I don't want all the rules?**  
A: Generated files are Markdown. Delete or modify what you don't need. The SKILL.md tells agents which files are optional.

## Implementation

See `discover.md`, `analyze.md`, `question.md`, and `generate.md` for the internal step-by-step guidance.
