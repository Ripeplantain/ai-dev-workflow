# Role docs as Claude Code subagents

Claude Code discovers subagents from `.claude/agents/`, recursively, at the project level (checked in) and from `~/.claude/agents/` at the user level. Write the project ones.

That is the same path this workflow keeps its role docs in, which is the point: **one file per role, no wrapper.** Frontmatter carries what Claude Code reads; the body is the role's instructions. There is no second copy to drift from.

Format checked against the official Claude Code subagent docs on 2026-11-17. If an installed version rejects a file, check that version's current docs and adjust; do not guess new keys.

## The file

```markdown
---
name: reviewer
description: Reviews a diff for correctness, security, project invariants, and checkpoint compliance. Use after implementation and before asking the user to commit.
model: opus
tools: Read, Grep, Glob, Bash
disallowedTools: Edit, Write, NotebookEdit
---

# Reviewer

**Job:** Find what is wrong with a diff before the user is asked to commit it.

Reads: `.claude/PROJECT.md`, `.claude/rules/checkpoints.md`, `.claude/rules/security.md`
Writes: nothing
Hands off to: main agent

## Before starting
...
```

Required: `name` (unique, ≤256 chars, cannot start with `-` or contain `:`) and `description`. Everything else is optional.

`name` must match the filename stem — `reviewer.md` holds `name: reviewer`. The validator checks this.

## Fields

**`description` is the dispatch trigger.** Claude Code decides whether to delegate from this field alone, so write what the role does and when to hand work to it. All subagent descriptions share one ~15,000-token budget, so a verbose description on six roles is a cost the main thread pays on every task. One or two sentences.

**`model`.** Aliases are `opus`, `sonnet`, `haiku`, `fable`, plus `inherit` and full model IDs. Map the tier from `references/roles.md`:

| Tier | `model` |
|---|---|
| strong | `opus` |
| default | `sonnet` |
| cheap | `haiku` |

Use `inherit` throughout when the user prefers one model everywhere. Say in the report which mapping you used.

**`tools` and `disallowedTools`.** Writing roles omit `tools` so they inherit everything. Read-only roles (planner, reviewer, investigator, evaluator when only reading) get `tools: Read, Grep, Glob, Bash` — Bash stays because they need to run tests and git read commands.

Bash is a write vector, so for read-only roles also set `disallowedTools: Edit, Write, NotebookEdit`. That is a real guard; `rules/checkpoints.md` is only an instruction, and an instruction is not a permission boundary. Do not rely on the checkpoints file alone where a field can enforce it.

**Other optional fields**, worth knowing but not written by default: `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `omitClaudeMd`, `effort` (`low`|`medium`|`high`|`xhigh`|`max`), `isolation: worktree`, `color`, `initialPrompt`. Add one only when the user asks for the behaviour it controls. If the user wants tiers expressed as reasoning effort rather than model, map `strong` → `high` and `default` → `medium` with `effort` and leave `model: inherit`.

Do not set `omitClaudeMd`. The role doc assumes the project context CLAUDE.md loads.

## The body

Everything after the frontmatter is the role's prompt. Keep the structure from `templates/agents/_role.md`: job, the contract lines (reads / writes / hands off to), **Before starting**, **Do**, **Don't**, **Return**.

Open the body with an instruction to read `.claude/PROJECT.md` and `.claude/rules/checkpoints.md`. A subagent starts with its own context; it does not inherit what the main agent has read.

Keep bodies under 80 lines. A role doc is loaded whole every time that role is dispatched.

## Pre-existing subagents

A repo may already have files in `.claude/agents/` that this skill did not write — the user's own, or another tool's. Leave them alone. List them in the report, and if one overlaps an installed role (a `code-reviewer` beside your `reviewer`), say so and ask: adopting theirs and skipping the role is usually the better answer than shipping both.

## Delegation section for CLAUDE.md

Claude Code delegates on its own from the `description` fields, but the main agent still needs the order the roles run in. Generate a short block like this, listing only installed roles:

```markdown
## Delegation
Delegate bounded work and ask each subagent to return a summary, not raw output:
- Before a non-trivial change: `planner`.
- Broad search or log reading: `investigator` (read-only, safe to run in parallel).
- After implementation: `tester`, then `reviewer`. Review must pass before you ask to commit.
For a one-line fix, work through the same roles yourself in that order, reading each role doc as you reach it.
```
