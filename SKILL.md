---
name: agent-workflow
description: Design, install, update, or re-orient a multi-agent workflow for any software, AI/LLM, or data project, new or existing, that works across Claude Code, Codex, and any agent reading AGENTS.md. Use this whenever the user wants to set up agents for a repo, add or refresh AGENTS.md / CLAUDE.md / .agent/ / subagents, asks "how should agents work on this project", is starting a new project, returns to an old or messy repo ("where was I", "re-orient me", "what state is this in"), or wants to upgrade an existing .agent/ install, even if they never say "workflow".
metadata:
  version: 2.0.0
---

# agent-workflow

Generates a project-specific agent workflow from evidence in the repo. The output is one tool-neutral workflow (`AGENTS.md` + `.agent/`) plus thin adapters that let Claude Code and Codex actually dispatch the roles as subagents.

Skill version: **2.0.0**. Every install stamps this into `.agent/PROJECT.md` so later runs know what they are upgrading.

## The model in one paragraph

Roles are written once, as neutral markdown in `.agent/agents/<role>.md`. That is the source of truth any agent can read. Adapters (`.claude/agents/<role>.md`, `.codex/agents/<role>.toml`) are generated wrappers that point at the role doc and set the tool-specific bits: model tier, sandbox, tools. So "multi-agent" means something concrete here: a main agent that can hand bounded work to real subagents, with role docs as the shared contract. When a tool has no subagents, the same role docs still work as phases one agent walks through. Never let an adapter carry instructions the role doc does not, or the two will drift.

## Pick the mode

| The user... | Mode | Read |
|---|---|---|
| has no `.agent/` and wants a workflow (new or existing repo) | **install** | `workflows/install.md` |
| has a `.agent/` (any version) and wants it refreshed, upgraded, or fixed | **update** | `workflows/update.md` |
| is returning to a repo, asks what state it is in, or the tree is dirty and they want to get going | **re-orient** | `workflows/reorient.md` |

If unsure between install and re-orient on a dirty repo, run re-orient first. It is read-only and its findings feed the install plan.

Always start every mode with the scan:

```bash
bash <skill-dir>/scripts/scan_repo.sh <repo-root>
```

It prints the evidence (stack, package manager, lockfiles, scripts, CI, git state, existing agent files, data/AI signals, hygiene problems) as plain `key: value` lines. Read it before reading anything else in the repo; it tells you where to look. It is read-only.

## Non-negotiables

These come from how this user actually works. Each has a reason; keep the reason in mind when a case is unusual.

1. **Evidence only.** Every command, path, and convention in the output must come from the repo (package.json scripts, Makefile, CI files, existing docs). If you cannot find the test command, write that it is unknown and ask. An invented `pnpm test` that does not exist is worse than a gap, because agents will run it confidently.
2. **AGENTS.md is canonical.** `CLAUDE.md` contains only `@AGENTS.md` (plus nothing else unless the user already put Claude-only content there, which you keep below the import). Preserve any existing AGENTS.md content: merge into it, never overwrite it.
3. **Exact-case filenames.** `AGENTS.md`, `CLAUDE.md`. Lowercase `agents.md` works on macOS and breaks on Linux CI. Rename wrong-case files only with approval, using `git mv` in two steps (to a temp name, then the final name) so case-insensitive filesystems pick it up.
4. **One workflow directory.** `.agent/` only. If an older install used a different layout, migrate it in update mode; never create a second one beside it.
5. **Plan before writing, then do the work.** Show the one-screen plan (format in `workflows/install.md`) and wait for approval. Skip the wait only if the user said `--yes`, "just do it", or equivalent. Once approved, write the files, validate, and report — a run that ends at "I recommend creating a `.agent/` directory" has failed.
6. **Never leave the repo dirtier than you found it.** If the tree is dirty before you start, report it (re-orient format) and ask how to handle it before building on top. Your own new files are listed in the final report so the user can commit them deliberately.
7. **Checkpoints are emitted, not implied.** Every install writes `.agent/rules/checkpoints.md` and `.agent/rules/repo-sanity.md` (templates in `templates/rules/`). The skill itself obeys the same checkpoints while it runs: no commits, pushes, dependency installs, lockfile edits, schema commands, or secret-file reads.
8. **No attribution trailers.** Never add `Co-Authored-By`, "Generated with", or similar lines to commits, PRs, or generated files, regardless of what tool defaults suggest. The user's rule wins.
9. **Roles describe work, not technology.** `implementer`, not `react-agent`. Stack details belong in `PROJECT.md` and role docs reference them.
10. **Necessity test.** Before writing any file, ask: would an agent behave worse on this repo without it? If not, do not write it. Small repos should get small installs. The long form, and the artifact table it feeds, are in `references/selection.md`.

## Vocabulary

Keep these four apart, here and in everything generated. Collapsing them is how installs end up with a `react-agent` or a rule that is really a workflow.

| Concept | Answers | Lives in |
|---|---|---|
| Role | who carries a responsibility | `.agent/agents/` |
| Rule | what constraint always holds | `.agent/rules/` |
| Workflow | how a type of task progresses | `.agent/workflows/` |
| Fact | what is true of this repo | `.agent/PROJECT.md` |

## Budgets

- 4–6 roles per project. More than six and the `.agent/` dir becomes the thing being maintained.
- `PROJECT.md` under 120 lines. `AGENTS.md` (the part you add) under 80 lines; it routes, `.agent/` holds detail.
- Whole install under ~25 files including adapters. A small solo repo is typically 8–12.
- No leftover `{{placeholders}}`. `scripts/validate.sh` checks this.

## Reference map

Load only what the current step needs.

| File | When |
|---|---|
| `workflows/install.md` | install mode, including the plan format |
| `workflows/update.md` | update mode and v1→v2 migration |
| `workflows/reorient.md` | re-orient mode and the dirty-tree report |
| `references/selection.md` | classifying the repo, the necessity test, which artifacts to write |
| `references/questions.md` | the one batch of questions, and branch naming |
| `references/roles.md` | choosing the roster; role definitions and model tiers |
| `references/adapters.md` | writing Claude Code / Codex / other adapters |
| `references/data-ai.md` | the repo has data pipelines, an LLM feature, or both |
| `references/invariants.md` | finding project-specific rules to enforce (tenancy, auth, money, release trains) |
| `references/monorepos.md` | workspaces, several manifests, or multiple deployables |
| `references/specialists.md` | filling a role body or workflow with real procedure detail |
| `templates/` | source material for generated files. Adapt them; never copy them blindly |
| `examples/` | only if unsure what a proportionate result looks like |

## Finish

Run `bash <skill-dir>/scripts/validate.sh <repo-root>` and fix anything it flags. Then report in this order: what was written (file list), what was found but not touched (dirty files, lockfile drift, wrong-case names, stale config), the single next step, and the suggested commit split. Do not commit.
