# agent-workflow

An installable skill for Claude Code. Point it at any repository — software, AI/LLM, or data — and it reads the evidence in that repo, works out what it actually needs, and writes a `CLAUDE.md` plus a `.claude/` directory whose role docs are real, dispatchable subagents.

> AI should adapt to the repository. The repository should not adapt to the AI.

## What it does

```text
scan_repo.sh → classify → decide artifacts → plan (you approve) → write → validate → report
```

- **Works from evidence.** Every command, path, and convention comes from the repo's manifests, CI, scripts, and docs. An invented `pnpm test` that does not exist is worse than an admitted gap, because agents run it confidently.
- **Plans before writing.** You get a one-screen plan — classification, roles, the exact file list, what it is skipping and why — and nothing is written until you approve it. `--yes` skips the wait, not the report.
- **Writes the smallest install that changes behaviour.** A small CLI gets 6–9 files. A large monorepo gets ~16. Every file has to pass the necessity test: would an agent behave worse here without it?
- **Preserves what exists.** An existing `CLAUDE.md` is merged into, never overwritten; an existing `AGENTS.md` is folded in and left on disk. Your `settings.json`, skills, commands, and your own subagents are never touched. Hand-edited files are left alone and listed in the report.
- **Never leaves the repo dirtier.** It does not commit, push, install dependencies, touch lockfiles, or run schema commands. If the tree is already dirty, it says so and asks before building on top.

## Three modes

| You... | Mode | What happens |
|---|---|---|
| have no workflow and want one | **install** | Scan, classify, plan, write on approval |
| have one from any version | **update** | Audit for drift, propose targeted fixes, migrate v1/v2 → v3 |
| are coming back to a repo after weeks | **re-orient** | Read-only report: dirty tree grouped by area, stashes, branch state, suggested commit split |

Re-orient exists because the most common real problem is work built and left uncommitted. It makes that legible before any agent piles new work on top of it.

## Install

The skill is a directory with a `SKILL.md` at its root. Claude Code loads skills from `~/.claude/skills/` (all projects) or a project's own `.claude/skills/`.

### One command

The [`skills`](https://github.com/vercel-labs/skills) CLI installs it for you. It needs Node.js.

```bash
npx skills add Ripeplantain/ai-dev-workflow -g -a claude-code
```

`-g` installs for all your projects; leave it off to install into the current project only.

### Manual install

```bash
git clone https://github.com/Ripeplantain/ai-dev-workflow.git ~/.claude/skills/agent-workflow
```

Update it with `git -C ~/.claude/skills/agent-workflow pull`. For one project only, clone into that project's `.claude/skills/agent-workflow` instead.

> **v2 → v3.** v3 targets Claude Code only. Where v2 wrote a tool-neutral `AGENTS.md` + `.agent/` plus adapters per tool, v3 writes `CLAUDE.md` + `.claude/`, and each role doc *is* its subagent — no wrapper, nothing to drift. Run update mode on a v2 repo and it migrates in place: moves the directory, folds each role doc into its adapter, makes `CLAUDE.md` canonical, and leaves your `AGENTS.md` and any other tool's adapters alone unless you say otherwise.

## Use

Open the target repository and ask the agent, for example:

```text
Use the agent-workflow skill to set up agents for this project.
```

```text
Use the agent-workflow skill to update this project's .claude/ directory.
```

```text
Use the agent-workflow skill to re-orient me — I have not touched this repo in two months.
```

## What gets generated

```text
CLAUDE.md                      canonical; routes into .claude/ and names when to delegate
.claude/
├── PROJECT.md                 stack, real commands, layout, invariants, version stamp
├── rules/
│   ├── checkpoints.md         hard stops: commit, push, deps, lockfiles, schema, secrets, cost
│   ├── repo-sanity.md         what not to add, and where to look first
│   └── …                      engineering, testing, security, design-system, data-contract, evals
├── agents/<role>.md           4–6 subagents: frontmatter Claude Code reads + the role's body
└── workflows/<task>.md        feature, fix, and the ones the repo earns
```

`.claude/agents/` is where Claude Code discovers subagents, so a role doc is not a document *about* an agent — it is the agent. Frontmatter carries `name`, `description`, `model`, and the tool permissions; the body is the role's instructions. One file, so there is nothing to keep in sync.

Read-only roles get `tools: Read, Grep, Glob, Bash` **and** `disallowedTools: Edit, Write, NotebookEdit`, because Bash is a write vector and a sentence in a rules file is not a permission boundary.

It stays out of the rest of `.claude/`: `settings.json`, `skills/`, `commands/`, `hooks/`, and any subagent you wrote yourself are yours, read for context and never written.

Repos with data pipelines or an LLM feature also get the data/AI layer: a data contract with halt and quarantine tiers, eval cases with graders ordered cheapest first, prompt versioning, and a paid-call cost checkpoint.

Worked examples: [small](examples/small.md), [medium with an LLM feature](examples/medium-llm.md), [large monorepo](examples/large-monorepo.md).

## How it is organized

| Path | Role |
|---|---|
| [SKILL.md](SKILL.md) | The orchestrator: modes, non-negotiables, budgets, what to load when |
| [workflows/](workflows/) | [install](workflows/install.md), [update](workflows/update.md), [reorient](workflows/reorient.md) |
| [references/](references/) | Loaded on demand: [selection](references/selection.md), [questions](references/questions.md), [roles](references/roles.md), [subagents](references/subagents.md), [data-ai](references/data-ai.md), [invariants](references/invariants.md), [monorepos](references/monorepos.md), [specialists](references/specialists.md) |
| [templates/](templates/) | Source material for generated files, never a checklist |
| [scripts/scan_repo.sh](scripts/scan_repo.sh) | Read-only evidence scan; every mode starts here |
| [scripts/validate.sh](scripts/validate.sh) | Checks a generated install |
| [examples/](examples/) | What a proportionate result looks like at three sizes |

The skill loads progressively: `SKILL.md`, then the workflow for the mode, then only the references the repo calls for. A repo with no UI never loads the design-system material; a single-package repo never loads the monorepo reference.

## Vocabulary

| Concept | Answers | Lives in |
|---|---|---|
| Role | who carries a responsibility | `.claude/agents/` |
| Rule | what constraint always holds | `.claude/rules/` |
| Workflow | how a type of task progresses | `.claude/workflows/` |
| Fact | what is true of this repo | `.claude/PROJECT.md` |

Roles describe work, not technology: `implementer`, never `react-agent`. Tiers are a planning word — `strong`, `default`, `cheap` become `opus`, `sonnet`, `haiku` in the role doc's `model:` field.

## Validating a generated workflow

```bash
~/.claude/skills/agent-workflow/scripts/validate.sh /path/to/project
```

It checks the exact-case `CLAUDE.md`, that it routes into `.claude/` and is not still a v2 `@AGENTS.md` pointer, the version stamp, subagent frontmatter (`name` matching the filename, a `description`, a recognised `model`, `disallowedTools` on read-only roles), leftover v2 `tier:` fields, subagents it did not write, a gitignored `.claude/`, leftover placeholders, broken links, missing referenced paths, attribution trailers, and the size budgets. If the project keeps its workflow in a directory other than `.claude/`, pass that name as a second argument. `--links <dir>` checks only relative links. Requires Bash 3.2 and standard Unix tools; the installer runs it itself.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Changes are recorded in [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE)
