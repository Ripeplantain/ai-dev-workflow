# agent-workflow

An installable skill for AI coding agents. Point it at any repository — software, AI/LLM, or data — and it reads the evidence in that repo, works out what it actually needs, and writes one tool-neutral agent workflow plus the thin adapters that let Claude Code and Codex dispatch the roles as real subagents.

> AI should adapt to the repository. The repository should not adapt to the AI.

## What it does

```text
scan_repo.sh → classify → decide artifacts → plan (you approve) → write → validate → report
```

- **Works from evidence.** Every command, path, and convention comes from the repo's manifests, CI, scripts, and docs. An invented `pnpm test` that does not exist is worse than an admitted gap, because agents run it confidently.
- **Plans before writing.** You get a one-screen plan — classification, roles, the exact file list, what it is skipping and why — and nothing is written until you approve it. `--yes` skips the wait, not the report.
- **Writes the smallest install that changes behaviour.** A small CLI gets 8–12 files. A large monorepo gets ~25. Every file has to pass the necessity test: would an agent behave worse here without it?
- **Preserves what exists.** An existing `AGENTS.md` is merged into, never overwritten. Hand-edited files are left alone and listed in the report.
- **Never leaves the repo dirtier.** It does not commit, push, install dependencies, touch lockfiles, or run schema commands. If the tree is already dirty, it says so and asks before building on top.

## Three modes

| You... | Mode | What happens |
|---|---|---|
| have no `.agent/` and want a workflow | **install** | Scan, classify, plan, write on approval |
| have a `.agent/` from any version | **update** | Audit for drift, propose targeted fixes, migrate v1 → v2 |
| are coming back to a repo after weeks | **re-orient** | Read-only report: dirty tree grouped by area, stashes, branch state, suggested commit split |

Re-orient exists because the most common real problem is work built and left uncommitted. It makes that legible before any agent piles new work on top of it.

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
git clone https://github.com/Ripeplantain/ai-dev-workflow.git ~/.agents/skills/agent-workflow
ln -s ~/.agents/skills/agent-workflow ~/.claude/skills/agent-workflow
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

To update every agent at once, run `git -C ~/.agents/skills/agent-workflow pull`.

For one project only, clone into that project's `.claude/skills/agent-workflow` (Claude Code) or `.agents/skills/agent-workflow` (most other agents).

> Upgrading from v1: the skill was called `ai-engineering-workflow`. Re-link it under the name `agent-workflow` and delete the old link, or both will load.

## Use

Open the target repository and ask the agent, for example:

```text
Use the agent-workflow skill to set up agents for this project.
```

```text
Use the agent-workflow skill to update this project's .agent/ directory.
```

```text
Use the agent-workflow skill to re-orient me — I have not touched this repo in two months.
```

## What gets generated

```text
AGENTS.md                      canonical; routes into .agent/ and names when to delegate
CLAUDE.md                      exactly "@AGENTS.md"
.agent/
├── PROJECT.md                 stack, real commands, layout, invariants, version stamp
├── rules/
│   ├── checkpoints.md         hard stops: commit, push, deps, lockfiles, schema, secrets, cost
│   ├── repo-sanity.md         what not to add, and where to look first
│   └── …                      engineering, testing, security, design-system, data-contract, evals
├── agents/<role>.md           4–6 neutral role docs, each with a tier
└── workflows/<task>.md        feature, fix, and the ones the repo earns
.claude/agents/<role>.md       adapter: tier → model, tools, points at the role doc
.codex/agents/<role>.toml      adapter: reasoning effort, sandbox, points at the role doc
```

Roles are written once as neutral markdown; the adapters are generated wrappers that carry only the tool-specific bits. Any agent that reads `AGENTS.md` — Cursor, Gemini CLI, Copilot — gets the workflow without an adapter. An adapter never carries an instruction its role doc does not, or the two drift.

Repos with data pipelines or an LLM feature also get the data/AI layer: a data contract with halt and quarantine tiers, eval cases with graders ordered cheapest first, prompt versioning, and a paid-call cost checkpoint.

Worked examples: [small](examples/small.md), [medium with an LLM feature](examples/medium-llm.md), [large monorepo](examples/large-monorepo.md).

## How it is organized

| Path | Role |
|---|---|
| [SKILL.md](SKILL.md) | The orchestrator: modes, non-negotiables, budgets, what to load when |
| [workflows/](workflows/) | [install](workflows/install.md), [update](workflows/update.md), [reorient](workflows/reorient.md) |
| [references/](references/) | Loaded on demand: [selection](references/selection.md), [questions](references/questions.md), [roles](references/roles.md), [adapters](references/adapters.md), [data-ai](references/data-ai.md), [invariants](references/invariants.md), [monorepos](references/monorepos.md), [specialists](references/specialists.md) |
| [templates/](templates/) | Source material for generated files, never a checklist |
| [scripts/scan_repo.sh](scripts/scan_repo.sh) | Read-only evidence scan; every mode starts here |
| [scripts/validate.sh](scripts/validate.sh) | Checks a generated install |
| [examples/](examples/) | What a proportionate result looks like at three sizes |

The skill loads progressively: `SKILL.md`, then the workflow for the mode, then only the references the repo calls for. A repo with no UI never loads the design-system material; a single-package repo never loads the monorepo reference.

## Vocabulary

| Concept | Answers | Lives in |
|---|---|---|
| Role | who carries a responsibility | `.agent/agents/` |
| Rule | what constraint always holds | `.agent/rules/` |
| Workflow | how a type of task progresses | `.agent/workflows/` |
| Fact | what is true of this repo | `.agent/PROJECT.md` |

Roles describe work, not technology: `implementer`, never `react-agent`. Tiers (`strong`, `default`, `cheap`) stay abstract in the role doc so the adapters can map them to each tool's models.

## Validating a generated workflow

```bash
~/.agents/skills/agent-workflow/scripts/validate.sh /path/to/project
```

It checks exact-case entry files, the `CLAUDE.md` pointer, the version stamp, role tiers, adapters mirroring roles, leftover placeholders, broken links, missing referenced paths, attribution trailers, and the size budgets. If the project keeps its workflow in a directory other than `.agent/`, pass that name as a second argument. `--links <dir>` checks only relative links. Requires Bash 3.2 and standard Unix tools; the installer runs it itself.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE)
