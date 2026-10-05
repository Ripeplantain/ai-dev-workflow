# Universal AI Engineering Workflow Skill

An installable skill for AI coding agents. Point it at any software repository and it inspects the project, works out what that project actually needs, and creates or updates a tailored AI engineering workflow in the repository's `.agent/` directory.

> AI should adapt to the repository. The repository should not adapt to the AI.

## What it does

```text
Inspect target repo → Understand architecture → Determine what it needs → Generate / update .agent/ → Validate
```

- **Does the setup.** Asked to set up a workflow, it writes the files, verifies them, and reports. It does not stop at recommendations.
- **Works from evidence.** Commands, paths, and conventions come from the repository's manifests, CI, code, and docs. Nothing is guessed.
- **Generates only what is needed.** A small tool may get two short files. A large monorepo gets agents, rules, workflows, and context. Templates are source material, never a checklist.
- **Preserves what exists.** Existing `AGENTS.md`, `CLAUDE.md`, contributor docs, and architecture docs stay authoritative and are linked, not duplicated.
- **Keeps it current.** Re-running it audits the existing `.agent/` against the repository and makes targeted corrections.

## Install

The skill is a directory with a `SKILL.md` at its root. Install it wherever your agent loads skills from.

### Any agent, one command

The [`skills`](https://github.com/vercel-labs/skills) CLI detects the agents on your machine and installs the skill for the ones you pick. It needs Node.js.

```bash
npx skills add Ripeplantain/ai-dev-workflow -g
```

`-g` installs for all your projects; leave it off to install into the current project only. To skip the prompts, name the agents:

```bash
npx skills add Ripeplantain/ai-dev-workflow -g -y -a claude-code -a codex -a cursor
```

### Manual install

Clone the skill once, then link it into the skills directory of each agent you use:

```bash
git clone https://github.com/Ripeplantain/ai-dev-workflow.git ~/.agents/skills/ai-engineering-workflow
ln -s ~/.agents/skills/ai-engineering-workflow ~/.claude/skills/ai-engineering-workflow
```

Repeat the `ln -s` line for each agent, creating the directory first if it does not exist:

| Agent | Skills directory |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| Cursor | `~/.cursor/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| GitHub Copilot | `~/.copilot/skills/` |
| OpenCode | `~/.config/opencode/skills/` |
| Windsurf | `~/.codeium/windsurf/skills/` |

To update every agent at once, run `git -C ~/.agents/skills/ai-engineering-workflow pull`.

For one project only, clone into that project's `.claude/skills/ai-engineering-workflow` (Claude Code) or `.agents/skills/ai-engineering-workflow` (most other agents).

An agent with no skills directory: clone the repository anywhere and tell the agent to read `SKILL.md` from that location.

## Use

Open the target repository and ask the agent, for example:

```text
Use the ai-engineering-workflow skill to set up the AI workflow for this project.
```

```text
Use the ai-engineering-workflow skill to update this project's .agent/ directory.
```

```text
Use the ai-engineering-workflow skill and show me what you would generate, without writing anything.
```

The agent inspects the repository, classifies it, decides which artifacts are justified, writes them, validates the result, reviews the diff, and reports what it did and what it skipped. It leaves the generated workflow uncommitted for you to review.

Once installed, the workflow tells agents how to handle Git on real tasks: a `<type>/<short-slug>` branch per task, one commit per finished unit, files staged by path, no attribution trailers, and no push or merge unless asked. A project's own branch and message conventions take precedence where they exist.

## What gets generated

Output depends on the repository. Typical shapes:

| Repository | Typical `.agent/` contents |
|---|---|
| Small tool or library | `PROJECT.md`, perhaps `RULES.md` and `WORKFLOW.md` |
| Standard production app | `PROJECT.md`, `agents/`, `rules/`, `workflows/`, selected `skills/` |
| Large repo or monorepo | The above plus `context/` (architecture, workspaces, design system) |

The installer also adds a short pointer to the project's existing agent entry file (or creates a minimal `AGENTS.md`) so agents find `.agent/`. That is the only change outside `.agent/`.

Worked examples: [small project](examples/small-project/README.md), [standard project](examples/standard-project/README.md), [monorepo](examples/monorepo/README.md).

## How it is organized

| Path | Role |
|---|---|
| [SKILL.md](SKILL.md) | The orchestrator: modes, procedure, and what to load when |
| [workflows/](workflows/) | `install` and `update`, plus task workflows (feature, bugfix, refactor, investigation, migration, UI feature, code review) |
| [rules/](rules/) | Constraints the skill itself follows, including [project-installation](rules/project-installation.md), which decides what gets generated |
| [references/](references/) | Detail loaded on demand: repository discovery, task complexity, context management, design tokens, monorepos, definition of done |
| [templates/](templates/) | Source material for generated project files |
| [specialist-skills/](specialist-skills/) | Focused procedures: commit, debugging, testing, database, API design, refactoring, security review |
| [examples/](examples/) | What a proportionate result looks like at three sizes |
| [scripts/validate-agent-dir.sh](scripts/validate-agent-dir.sh) | Checks a generated `.agent/` for placeholders, broken references, and a missing entry pointer |

The skill loads progressively. An agent reads `SKILL.md`, then the workflow for the mode, then only the references and templates the repository calls for. A project with no UI never loads the design-system material; a single-package project never loads the monorepo reference.

## Concepts

| Concept | Answers |
|---|---|
| Agent | Who is carrying a responsibility (planner, investigator, implementer, tester, reviewer) |
| Skill | What specialized procedure is needed (debugging, database, security review) |
| Workflow | How a type of task progresses (feature, bugfix, migration) |
| Rule | What constraints always hold (repo sanity, testing, security) |

Task effort scales with a five-level complexity scale, L0 (trivial) to L4 (critical or architectural), defined in [references/task-complexity.md](references/task-complexity.md).

## Validating a generated workflow

```bash
~/.agents/skills/ai-engineering-workflow/scripts/validate-agent-dir.sh /path/to/project
```

Adjust the path to wherever you installed the skill. The installer runs this itself. It requires only Bash and standard Unix tools.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE)
