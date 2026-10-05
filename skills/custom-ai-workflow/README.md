# custom-ai-workflow Skill

Automatically set up the Universal AI Engineering Skill in any repository by analyzing conventions, generating customized documentation, and asking clarifying questions.

## Overview

The custom-ai-workflow skill is a **meta-tool** that helps you adopt the Universal AI Engineering Skill into a new repository. It:

1. **Discovers** your repository's actual structure, tooling, conventions, and patterns
2. **Analyzes** the project context (type, maturity, tech stack, team)
3. **Asks questions** when uncertain (with candidate options)
4. **Generates** a complete, customized AI workflow:
   - `.agent/PROJECT.md` — project context and workflows
   - `.agent/AGENTS.md` — roles suited to your project type
   - `.agent/context/` — architecture and design decisions
   - `rules/` — engineering standards tailored to your stack
   - `references/` — discovery outputs and task complexity levels
5. **Commits** the generated files with documented assumptions

## When to Use

Use this skill when:

- **Setting up a new repository** with AI agent support
- **Migrating an existing repo** to use AI agents
- **Documenting conventions** that AI agents should follow
- **Creating team-wide guidelines** for AI-assisted development

Do **not** use if:

- Your repository already has `.agent/PROJECT.md` (it's already adopted)
- You just need general guidance (use the Universal AI Engineering Skill directly instead)

## Installation

The skill lives in `skills/custom-ai-workflow/` in this repository. To use it:

### Option 1: Copy the Skill Folder

```bash
# Copy to your Claude Code skills directory
cp -r skills/custom-ai-workflow/ ~/.claude/skills/custom-ai-workflow/

# Or create a symlink (for development)
ln -s /path/to/ai-dev-workflow/skills/custom-ai-workflow ~/.claude/skills/custom-ai-workflow
```

### Option 2: Load from Repository

When invoking Claude Code:

```bash
/custom-ai-workflow --skill-path /path/to/ai-dev-workflow/skills/custom-ai-workflow
```

## Usage

### Basic Usage

In the repository you want to adopt the skill:

```bash
/custom-ai-workflow
```

The skill will:
1. Discover your repo
2. Analyze context
3. Ask clarifying questions
4. Generate files
5. Show you what will be committed
6. Commit with documented assumptions

### Options

```bash
# Analyze a specific subdirectory (for monorepos)
/custom-ai-workflow --path ./apps/web

# Use a template scaffold (minimal, standard, or monorepo)
/custom-ai-workflow --template standard

# Dry-run: show what would be generated without committing
/custom-ai-workflow --dry-run

# Re-run (force overwrite) if you've updated conventions
/custom-ai-workflow --force

# Update only the decisions (re-answer questions without re-discovering)
/custom-ai-workflow --update-decisions

# Verbose output (show discovery details)
/custom-ai-workflow --verbose
```

## What Gets Generated

### `.agent/PROJECT.md`

Project context guide — tells agents:
- Project overview and structure
- Workflows available for your project
- Commands to run
- Special concerns (auth, payments, PII)
- Quick reference for team conventions

**Customized for**: Your repo's languages, frameworks, tools, deployment platform

### `.agent/AGENTS.md`

Describes optional subagent roles:
- **Planner**: For L2+ features, cross-boundary changes
- **Investigator**: For bugs, performance issues
- **Reviewer**: For code review and verification
- **Implementer** (optional): For larger features

Each role includes:
- When to use it
- Responsibilities
- Success criteria
- Handoff format

**Customized for**: Your project type, team size, code review process

### `rules/` Directory

Canonical engineering rules tailored to your stack:

- `engineering.md` — language-specific conventions (TypeScript, Go, Python, Rust, etc.)
- `testing.md` — testing framework and ceremony levels
- `architecture.md` — project structure and patterns
- `git.md` — Git workflow and commit conventions
- `security.md` — auth, payments, PII handling (if applicable)
- `design-system.md` — design tokens, components, theming (if UI project)

Each rule file includes:
- Actual tool versions discovered (eslint v8, prettier v3, etc.)
- Real commands from your repo (`npm test`, `go test ./...`, etc.)
- Examples from your codebase

### `references/` Directory

Reference materials generated from discoveries:

- `repository-discovery.md` — full discovery output
- `task-complexity.md` — L0-L4 examples tailored to your project
- `definition-of-done.md` — checklist customized to your team

### `.agent/decisions.md`

Records all decisions made during adoption:

```markdown
## Testing
- Primary Framework: Jest (Q1: Candidate A)
- Coverage Target: 70%+ (Q2: Candidate B)

## Code Review
- Requirement: Peer review for L2+ (Q3: Candidate A)

[etc.]
```

This file can be edited and re-read if conventions change.

## File Structure

```
skills/custom-ai-workflow/
├── SKILL.md                 ← Skill definition (read this first)
├── discover.md              ← Step 1: Repository discovery protocol
├── analyze.md               ← Step 2: Analysis & classification
├── question.md              ← Step 3: Clarifying questions with options
├── generate.md              ← Step 4: File generation logic
├── templates/               ← Parametrized templates
│   ├── project.template.md
│   ├── agents.template.md
│   ├── rules/
│   │   ├── engineering.template.md
│   │   ├── testing.template.md
│   │   ├── architecture.template.md
│   │   ├── git.template.md
│   │   ├── security.template.md
│   │   └── design-system.template.md
│   └── references/
│       ├── repository-discovery.template.md
│       ├── task-complexity.template.md
│       └── definition-of-done.template.md
├── scenarios/               ← Example workflows for different stacks
│   ├── typescript-web-app.scenario.md
│   ├── go-microservice.scenario.md
│   ├── python-api.scenario.md
│   └── monorepo.scenario.md
└── README.md                ← This file
```

## Example: TypeScript Web App

**Task**: Set up a Next.js + React app

**Command**:
```bash
cd my-next-app
/custom-ai-workflow
```

**Discovery finds**:
- package.json with React, Next.js, Jest, Vitest, Tailwind
- TypeScript strict mode
- GitHub Actions deployment to Vercel

**Analysis**:
- Type: Web App
- Language: TypeScript
- Framework: Next.js 14
- Testing: Jest (primary) + Vitest (integration)

**Questions asked**:
```
🤔 Which test framework is primary?
A) Jest (unit tests)
B) Vitest (faster)
C) Both equally

🤔 Design tokens format?
A) Tailwind classes
B) CSS variables
```

**Generated**:
- `.agent/PROJECT.md` customized for Next.js + React
- `.agent/context/` with architecture decisions
- `rules/engineering.md` with TypeScript conventions
- `rules/testing.md` with Jest + Vitest ceremony levels
- `rules/design-system.md` with Tailwind + theming

**Commit**:
```
adopt: initialize AI workflow for my-next-app

Discovered:
- Next.js 14 + React 18
- TypeScript strict mode
- Jest + Vitest
- Tailwind CSS

Generated:
- .agent/PROJECT.md, .agent/AGENTS.md
- .agent/context/ with architecture
- rules/ with TypeScript conventions
- references/ with task complexity examples

Assumptions:
- Jest is primary (Jest for unit, Vitest for integration)
- Code review required L2+
- Tailwind classes for tokens (not CSS vars)
```

## Scenarios

The `scenarios/` folder contains detailed walkthroughs showing how the skill adapts for:

- **TypeScript Web App** (`typescript-web-app.scenario.md`)
  - Next.js, React, Jest, Vitest, Tailwind, Vercel
  
- **Go Microservice** (`go-microservice.scenario.md`)
  - Gin REST API, PostgreSQL, sqlc, golang-migrate, Docker, Kubernetes
  
- **Python API** (`python-api.scenario.md`)
  - FastAPI, SQLAlchemy, pytest, Docker, AWS
  
- **Monorepo** (`monorepo.scenario.md`)
  - pnpm workspaces, Turborepo, multiple apps and packages

Each scenario shows:
1. What the skill discovers
2. Questions asked
3. Generated files (excerpts)
4. Example agent interactions

**Read these to understand how the skill adapts to different stacks.**

## How It Works

### The 4-Step Process

```
DISCOVER → ANALYZE → ASK → GENERATE → COMMIT
```

1. **DISCOVER** (`discover.md`)
   - Run bash commands to find actual tooling
   - Detect languages, frameworks, testing, linting, deployment
   - Detect architecture patterns, Git conventions, special concerns

2. **ANALYZE** (`analyze.md`)
   - Classify project type (web app, API, library, monorepo, etc.)
   - Profile tech stack
   - Assess maturity and team size
   - Identify special concerns (auth, payments, PII)

3. **ASK** (`question.md`)
   - For each ambiguity, ask with 2-4 candidate options
   - Examples: "Which test framework is primary?"
   - Record answers in `.agent/decisions.md`

4. **GENERATE** (`generate.md`)
   - Load parametrized templates
   - Replace `[PLACEHOLDERS]` with discovered values
   - Include/exclude sections based on project type
   - Create `.agent/PROJECT.md`, `rules/`, `references/`

5. **COMMIT**
   - List discovered facts
   - List assumptions (changeable)
   - Commit to git with documented decisions

### Key Innovation: Language-Agnostic

The templates adapt based on what's discovered:

- If `go.mod` exists → load Go conventions, golang commands
- If `pyproject.toml` exists → load Python conventions, pytest commands
- If `Cargo.toml` exists → load Rust conventions, cargo commands
- If `Dockerfile` exists → plan for containerization concerns

No hardcoded examples for "TypeScript app" or "Python API". Instead, **templates parametrize based on discoveries**.

## Troubleshooting

### "The skill found the wrong thing"

The skill uses evidence-based discovery. If it's wrong:
1. Check what it actually discovered (see verbose output)
2. Verify the signals are correct (does `package.json` actually use Jest?)
3. Re-run with `--force` to re-discover

### "I want to change a decision"

Edit `.agent/decisions.md` and regenerate with `--force`.

### "Can I customize the generated files?"

Yes! After generation:
1. Edit the files directly
2. Update `.agent/decisions.md` if decisions changed
3. Commit

The generated files are yours to modify. They're not locked in.

### "The skill didn't generate a rule I need"

The skill generates rules for:
- Language (TypeScript, Go, Python, Rust)
- Framework (if detected)
- Testing (primary framework)
- Architecture (project structure)
- Git (workflow)
- Special concerns (auth, payments, PII)
- Design system (if UI project)

If something's missing:
1. Create the rule file manually
2. Reference it in `.agent/PROJECT.md`
3. Re-run with `--force` won't overwrite (if using `--preserve-custom`)

### "How do I share this with my team?"

Commit the generated files to your repo:

```bash
git add .agent/ rules/ references/
git commit -m "adopt: initialize AI workflow"
git push
```

Your team can now:
1. Pull the changes
2. Read `.agent/PROJECT.md` to understand the workflow
3. Ask Claude Code agents to use the skill

## Contributing

Improvements to the skill are welcome:

1. **Better discovery**: Add detection for new tools/frameworks
2. **Better questions**: Identify common ambiguities
3. **Better templates**: Improve rule file content
4. **Better scenarios**: Add examples for different stacks

## See Also

- [`SKILL.md`](SKILL.md) — the skill definition itself
- [`discover.md`](discover.md) — repository discovery protocol
- [`question.md`](question.md) — clarifying questions
- [`scenarios/`](scenarios/) — example workflows for different stacks
- [Universal AI Engineering Skill](../) — the parent skill this adopts

---

**The skill itself uses the skill.** This meta-skill is generated using the custom-ai-workflow process, making it a good reference for how the skill works.
