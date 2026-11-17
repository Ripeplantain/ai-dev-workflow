---
name: agent-workflow
description: Design, install, update, or re-orient a Claude Code agent workflow for any software, AI/LLM, or data project, new or existing. Use this whenever the user wants to set up agents for a repo, add or refresh CLAUDE.md / .claude/ / subagents, asks "how should agents work on this project", is starting a new project, returns to an old or messy repo ("where was I", "re-orient me", "what state is this in"), or wants to upgrade an existing .claude/ install, even if they never say "workflow".
metadata:
  version: 3.0.0
---

# agent-workflow

Generates a project-specific Claude Code workflow from evidence in the repo: `CLAUDE.md` plus a `.claude/` directory of roles, rules, workflows, and project facts.

Skill version: **3.0.0**. Every install stamps this into `.claude/PROJECT.md` so later runs know what they are upgrading.

## The model in one paragraph

Roles live at `.claude/agents/<role>.md`, which is where Claude Code discovers subagents. One file per role: frontmatter carries the wiring Claude Code reads (`name`, `description`, `model`, and tool permissions), and the body is the role's actual instructions. There is no second copy and no adapter, so there is nothing to drift. "Multi-agent" means something concrete here: a main agent that hands bounded work to real subagents, each with a single file defining it. When the work does not warrant dispatching a subagent, the same files still read as phases one agent walks through in order.

## Pick the mode

| The user... | Mode | Read |
|---|---|---|
| has no `.claude/` workflow and wants one (new or existing repo) | **install** | `workflows/install.md` |
| has a workflow (any version, any layout) and wants it refreshed, upgraded, or fixed | **update** | `workflows/update.md` |
| is returning to a repo, asks what state it is in, or the tree is dirty and they want to get going | **re-orient** | `workflows/reorient.md` |

A repo with `.claude/settings.json` or `.claude/skills/` but no `PROJECT.md`, roles, or rules has Claude Code configured, not a workflow installed. That is install, not update.

If unsure between install and re-orient on a dirty repo, run re-orient first. It is read-only and its findings feed the install plan.

Always start every mode with the scan:

```bash
bash <skill-dir>/scripts/scan_repo.sh <repo-root>
```

It prints the evidence (stack, package manager, lockfiles, scripts, CI, git state, existing agent files, data/AI signals, hygiene problems) as plain `key: value` lines. Read it before reading anything else in the repo; it tells you where to look. It is read-only.

## Non-negotiables

These come from how this user actually works. Each has a reason; keep the reason in mind when a case is unusual.

1. **Evidence only.** Every command, path, and convention in the output must come from the repo (package.json scripts, Makefile, CI files, existing docs). If you cannot find the test command, write that it is unknown and ask. An invented `pnpm test` that does not exist is worse than a gap, because agents will run it confidently.
2. **CLAUDE.md is canonical.** It is the file Claude Code loads on every task, so it holds the routing and nothing more: facts live in `.claude/PROJECT.md`, detail in `.claude/`. Preserve any existing CLAUDE.md content — merge into it, never overwrite it.
3. **An existing AGENTS.md is content, not a target.** Repos arrive with one, from this skill's v2 or from another tool. Read it, merge what it says into `CLAUDE.md`, and leave the file alone unless the user approves reducing it to a pointer (`workflows/update.md` §4). Never write a fresh AGENTS.md, and never leave two files claiming to be canonical.
4. **Exact-case filenames.** `CLAUDE.md`. Lowercase `claude.md` works on macOS and breaks on Linux CI. Rename wrong-case files only with approval, using `git mv` in two steps (to a temp name, then the final name) so case-insensitive filesystems pick it up.
5. **One workflow directory.** `.claude/` only. If an older install used a different layout, migrate it in update mode; never create a second one beside it.
6. **Role docs are the subagent files.** One file per role at `.claude/agents/<role>.md`, with frontmatter Claude Code actually reads. Never split a role across a definition and a wrapper — that is the drift this version exists to remove.
7. **Plan before writing, then do the work.** Show the one-screen plan (format in `workflows/install.md`) and wait for approval. Skip the wait only if the user said `--yes`, "just do it", or equivalent. Once approved, write the files, validate, and report — a run that ends at "I recommend creating a `.claude/` directory" has failed.
8. **Never leave the repo dirtier than you found it.** If the tree is dirty before you start, report it (re-orient format) and ask how to handle it before building on top. Your own new files are listed in the final report so the user can commit them deliberately.
9. **Checkpoints are emitted, not implied.** Every install writes `.claude/rules/checkpoints.md` and `.claude/rules/repo-sanity.md` (templates in `templates/rules/`). The skill itself obeys the same checkpoints while it runs: no commits, pushes, dependency installs, lockfile edits, schema commands, or secret-file reads.
10. **No attribution trailers.** Never add `Co-Authored-By`, "Generated with", or similar lines to commits, PRs, or generated files, regardless of what tool defaults suggest. The user's rule wins.
11. **Roles describe work, not technology.** `implementer`, not `react-agent`. Stack details belong in `PROJECT.md` and role docs reference them.
12. **Necessity test.** Before writing any file, ask: would an agent behave worse on this repo without it? If not, do not write it. Small repos should get small installs. The long form, and the artifact table it feeds, are in `references/selection.md`.

## Writing inside `.claude/`

The workflow shares a directory with Claude Code's own configuration, so stay out of its way.

| Path | Owner | Rule |
|---|---|---|
| `.claude/agents/` | shared | Role docs. One per installed role; leave any pre-existing subagent alone and report it |
| `.claude/PROJECT.md`, `.claude/rules/`, `.claude/workflows/` | this skill | Written and maintained here |
| `.claude/settings.json`, `.claude/settings.local.json` | the user | Never write. Read for context only; `settings.local.json` may hold secrets |
| `.claude/skills/`, `.claude/commands/`, `.claude/hooks/` | the user | Never write unasked. Installed skills are not part of the workflow |

`.claude/settings.local.json` is normally gitignored. Check `.gitignore` before writing anything into `.claude/`: if the whole directory is ignored, say so in the report — the workflow will not reach the user's team.

## Vocabulary

Keep these four apart, here and in everything generated. Collapsing them is how installs end up with a `react-agent` or a rule that is really a workflow.

| Concept | Answers | Lives in |
|---|---|---|
| Role | who carries a responsibility | `.claude/agents/` |
| Rule | what constraint always holds | `.claude/rules/` |
| Workflow | how a type of task progresses | `.claude/workflows/` |
| Fact | what is true of this repo | `.claude/PROJECT.md` |

## Budgets

- 4–6 roles per project. More than six and the `.claude/` dir becomes the thing being maintained.
- `PROJECT.md` under 120 lines. `CLAUDE.md` (the part you add) under 80 lines; it routes, `.claude/` holds detail.
- Subagent `description` fields share one ~15,000-token budget across all roles. One or two sentences each.
- Whole install under ~20 files. A small solo repo is typically 6–9.
- No leftover `{{placeholders}}`. `scripts/validate.sh` checks this.

## Reference map

Load only what the current step needs.

| File | When |
|---|---|
| `workflows/install.md` | install mode, including the plan format |
| `workflows/update.md` | update mode, and migration from v1 or v2 |
| `workflows/reorient.md` | re-orient mode and the dirty-tree report |
| `references/selection.md` | classifying the repo, the necessity test, which artifacts to write |
| `references/questions.md` | the one batch of questions, and branch naming |
| `references/roles.md` | choosing the roster; role definitions and model choice |
| `references/subagents.md` | the role-doc format: frontmatter fields, tool permissions, delegation |
| `references/data-ai.md` | the repo has data pipelines, an LLM feature, or both |
| `references/invariants.md` | finding project-specific rules to enforce (tenancy, auth, money, release trains) |
| `references/monorepos.md` | workspaces, several manifests, or multiple deployables |
| `references/specialists.md` | filling a role body or workflow with real procedure detail |
| `templates/` | source material for generated files. Adapt them; never copy them blindly |
| `examples/` | only if unsure what a proportionate result looks like |

## Finish

Run `bash <skill-dir>/scripts/validate.sh <repo-root>` and fix anything it flags. Then report in this order: what was written (file list), what was found but not touched (dirty files, lockfile drift, wrong-case names, stale config), the single next step, and the suggested commit split. Do not commit.
