# [PROJECT_NAME] AI Workflow

**v0.1 · customized [DATE]**

> AI should adapt to the repository. The repository should not adapt to the AI.

This skill helps AI agents work safely in [PROJECT_NAME] by understanding its conventions, tools, and constraints.

## The Lifecycle

Use this protocol, with ceremony proportional to risk:

```
DISCOVER → UNDERSTAND → CLASSIFY → PLAN → IMPLEMENT → VERIFY → REVIEW → CLEAN → REPORT
```

**Project type**: [PROJECT_TYPE]  
**Primary language**: [PRIMARY_LANGUAGE]  
**Tech stack**: [TECH_STACK_SUMMARY]  
**Team**: [TEAM_SIZE] ([TEAM_MATURITY])

## Quick Start

1. Read this file and the relevant rules
2. Load the workflow for your task type
3. Follow the guidance

**Common workflows**:
[CONDITIONAL:has-features]
- Feature development: `rules/feature.md`
[CONDITIONAL:has-bugs]
- Bug fixes: `rules/bugfix.md`
[CONDITIONAL:has-tests]
- Testing: `rules/testing.md`
[CONDITIONAL:is-ui]
- UI changes: `rules/design-system.md`

## Always Load These

For any meaningful change:

- `rules/engineering.md` — [LANGUAGE] conventions and style
- `rules/architecture.md` — project structure and patterns
- `rules/git.md` — Git workflow and commit conventions

Load conditionally:
[CONDITIONAL:has-auth]
- `rules/security.md` — authentication and authorization
[CONDITIONAL:has-payments]
- `rules/security.md` — payment and PII handling
[CONDITIONAL:is-ui]
- `rules/design-system.md` — tokens, components, theming
[CONDITIONAL:has-tests]
- `rules/testing.md` — testing framework and approach

## Load by Task Type

| Task | Load | Notes |
| --- | --- | --- |
| Feature | `rules/feature.md` | Larger changes, cross-boundary work |
| Bug fix | `rules/bugfix.md`, `rules/debugging.md` | Investigation, reproduction, verification |
[CONDITIONAL:is-ui]
| UI change | `rules/design-system.md`, `references/design-tokens.md` | Design tokens, components, patterns |
[CONDITIONAL:is-monorepo]
| Monorepo change | `rules/architecture.md` | Workspace boundaries, shared packages |
| Refactor | `rules/architecture.md` | Preserve patterns, avoid scope creep |
| Security | `rules/security.md` | Auth, payments, PII, secrets |

## Ceremonies by Complexity

**L0 (Trivial)**: Typo, formatting, version number
- Skip planning
- No review

**L1 (Simple)**: Single file, single responsibility
- No planning needed
- Self-review only

**L2 (Moderate)**: New feature, test coverage, multiple files
[CONDITIONAL:planning-on-l2]
- Plan required
- Tests required
- Code review required

**L3+ (Substantial+)**: API changes, architecture, migration
- Extensive planning required
- Full test suite
- Security/performance review

See `references/task-complexity.md` for examples.

## Essential Commands

[LANGUAGE:typescript]
```bash
npm test                  # Run [PRIMARY_TEST_FRAMEWORK]
npm run lint              # ESLint + Prettier
npm run build             # [BUILD_TOOL]
npm run dev               # Dev server on http://localhost:[PORT]
[OTHER_SCRIPTS]
```

[LANGUAGE:go]
```bash
go test ./...             # Run tests
go run main.go            # Run program
go build                  # Build binary
make dev                  # Start dev environment
[OTHER_SCRIPTS]
```

[LANGUAGE:python]
```bash
pytest                    # Run tests
python -m black .         # Format
flake8 .                  # Lint
python app.py             # Run app
make dev                  # Start dev environment
[OTHER_SCRIPTS]
```

[LANGUAGE:rust]
```bash
cargo test                # Run tests
cargo build               # Build
cargo run                 # Run
cargo fmt                 # Format
cargo clippy              # Lint
[OTHER_SCRIPTS]
```

## Project Context

**Repository Type**: [REPO_TYPE]  
[CONDITIONAL:is-monorepo]
**Monorepo**: [MONOREPO_TOOL] with [NUM_PACKAGES] packages  
**Packages**: [PACKAGE_LIST]

**Key Tools**:
- Build: [BUILD_TOOL]
- Test: [PRIMARY_TEST_FRAMEWORK] [SECONDARY_FRAMEWORKS]
- Lint: [LINTERS]
- Format: [FORMATTERS]
- Deployment: [DEPLOYMENT_PLATFORM]
[CONDITIONAL:has-database]
- Database: [DATABASE_TYPE]

**Special Concerns**:
[CONDITIONAL:has-auth]
- Authentication: [AUTH_APPROACH]
[CONDITIONAL:has-payments]
- Payments: [PAYMENT_PROCESSOR]
[CONDITIONAL:has-realtime]
- Real-time: [REALTIME_APPROACH]
[CONDITIONAL:has-pii]
- PII handling: encrypted, retention [RETENTION_POLICY]

## Agents

See `AGENTS.md` for optional agent roles:
- **Planner**: For L2+ features, cross-boundary changes
- **Investigator**: For bugs, performance issues
- **Reviewer**: For code review and verification

## Agent Instructions

When given this skill, follow this lifecycle:

1. **Discover**: Run actual commands (see `references/repository-discovery.md`)
2. **Understand**: Read existing code, comments, tests
3. **Classify**: What complexity level? (see `references/task-complexity.md`)
4. **Plan**: Only for L2+ (create brief plan document)
5. **Implement**: Smallest correct change, reuse abstractions
6. **Verify**: Run commands from this file, never guessed ones
7. **Review**: Critique as if another engineer implemented
8. **Clean**: Remove temp files, test artifacts
9. **Report**: What changed, what verified, what uncertain

## Troubleshooting

**"I can't find [tool]"**: Check the actual command in:
- `package.json` scripts (JavaScript)
- `Makefile` (common tools)
- `.github/workflows/` (CI commands)

**"Which test framework?"**: Load `rules/testing.md`

**"Should I refactor?"**: Refactor only if it's required for the task. See `rules/architecture.md`

**"Is this secure?"**: Load `rules/security.md` if task touches auth, payments, or user data

**"Do I need planning?"**: Yes if L2+. See `references/task-complexity.md`

## References

- `rules/` — canonical engineering rules
- `references/` — discovery data, task complexity, definition of done
- `AGENTS.md` — optional agent roles
- `.ai/questions-answered.md` — team decisions on ambiguities

## Modified Assumptions?

If project conventions have changed, regenerate with:

```bash
/custom-ai-workflow --force
```

This will ask questions again and update all files.

## Contributing

Changes to this file:
1. Edit directly
2. Update `.ai/questions-answered.md` if decisions changed
3. Commit with explanation

Questions about this project? Check:
1. This file (SKILL.md)
2. Relevant `rules/` file
3. Comments in the code
4. Ask the team (see AGENTS.md for contacts)
