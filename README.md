# custom-ai-workflow Skill

A Claude Code skill that automatically adopts the Universal AI Engineering Skill into any repository.

## What It Does

The skill:

1. **Discovers** your repository's actual conventions, tooling, and patterns
2. **Analyzes** your project (type, maturity, tech stack, team)
3. **Asks questions** when uncertain (with options to choose from)
4. **Generates** a complete AI workflow setup:
   - `.ai/SKILL.md` — customized root orchestrator
   - `.ai/AGENTS.md` — roles suited to your project
   - `rules/` — engineering standards tailored to your stack
   - `references/` — discovery outputs and task complexity levels
5. **Commits** everything with documented assumptions

## Installation

```bash
cp -r skills/custom-ai-workflow ~/.claude/skills/custom-ai-workflow
```

## Usage

In any repository:

```bash
/custom-ai-workflow
```

The skill will discover, analyze, ask questions, and generate files. Answer a few questions and it's done.

## Examples

See the scenarios for walkthroughs:

- **TypeScript Web App** — Next.js + React + Jest + Tailwind
  - [`scenarios/typescript-web-app.scenario.md`](skills/custom-ai-workflow/scenarios/typescript-web-app.scenario.md)

- **Go Microservice** — Gin + PostgreSQL + sqlc
  - [`scenarios/go-microservice.scenario.md`](skills/custom-ai-workflow/scenarios/go-microservice.scenario.md)

- **Python API** — FastAPI + SQLAlchemy + pytest
  - [`scenarios/python-api.scenario.md`](skills/custom-ai-workflow/scenarios/python-api.scenario.md)

## Documentation

See the skill folder for complete documentation:

- **`SKILL.md`** — Skill overview
- **`README.md`** — Installation and usage
- **`discover.md`** — Discovery protocol (what it detects)
- **`analyze.md`** — Analysis framework (how it classifies)
- **`question.md`** — Question library (what it asks)
- **`generate.md`** — Generation logic (how it creates files)
- **`scenarios/`** — Example walkthroughs for different stacks

## Folder Structure

```
skills/custom-ai-workflow/          The complete skill
├── SKILL.md
├── README.md
├── discover.md
├── analyze.md
├── question.md
├── generate.md
├── templates/                      Parametrized templates
│   ├── skill.template.md
│   ├── agents.template.md
│   └── rules/
├── scenarios/                      Example walkthroughs
│   ├── typescript-web-app.scenario.md
│   ├── go-microservice.scenario.md
│   └── python-api.scenario.md
└── COMPLETENESS.md                 Implementation status
```

## Key Features

✅ **Language-agnostic** — Works with TypeScript, Go, Python, Rust, Java, Ruby, etc.  
✅ **Discovery-driven** — Detects from evidence, never assumes  
✅ **Question-based** — Asks ~20 clarifying questions with options  
✅ **Conditional** — Generates only what's relevant to your project  
✅ **Portable** — Copy the skill folder anywhere  
✅ **Documented** — 5,000+ lines of guides and examples  

## What Gets Generated

When you run the skill, it generates:

- **`.ai/SKILL.md`** — Your repo's customized workflow guide
- **`.ai/AGENTS.md`** — Agent roles (planner, investigator, reviewer)
- **`rules/engineering.md`** — Language-specific conventions
- **`rules/testing.md`** — Testing framework and ceremony levels
- **`rules/architecture.md`** — Project structure patterns
- **`rules/git.md`** — Git workflow conventions
- **`rules/security.md`** — Auth, payments, PII handling (if applicable)
- **`rules/design-system.md`** — Design tokens and theming (if UI project)
- **`references/task-complexity.md`** — L0-L4 examples for your project
- **`.ai/questions-answered.md`** — Record of decisions made

All customized to your specific project's stack, maturity, and team.

## Quick Start

```bash
# 1. Copy the skill to Claude Code
cp -r skills/custom-ai-workflow ~/.claude/skills/custom-ai-workflow

# 2. Go to your repository
cd /path/to/your-repo

# 3. Run the skill
/custom-ai-workflow

# 4. Answer a few questions
# (or just press Enter to accept defaults)

# 5. Review what will be committed
# (the skill shows you the changes first)

# 6. Done!
# Your repo now has .ai/SKILL.md with all conventions documented
```

## Contributing

Improvements welcome:

- Better discovery for new tools/frameworks
- More questions for common ambiguities
- Better templates or scenarios
- Support for additional languages

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines.

## License

MIT. See [`LICENSE`](LICENSE).

---

**Ready to use?** Install the skill and run it on any repository to automatically set up AI agent support.
