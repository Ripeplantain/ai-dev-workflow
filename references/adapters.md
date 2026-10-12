# Adapters

An adapter makes a neutral role doc dispatchable in a specific tool. Keep adapters thin: identity, when to use, tier → model, permissions, and an instruction to read the role doc. The behaviour lives in `.agent/agents/<role>.md`.

Formats change. Both formats below were checked against the official docs on 2026-10-12. If the user's installed tool rejects a file, check that tool's current docs and adjust; do not guess new keys.

## Claude Code — `.claude/agents/<role>.md`

Markdown with YAML frontmatter, discovered recursively from `.claude/agents/` (project, checked in) or `~/.claude/agents/` (user-level). Write the project one.

Required: `name` (unique, ≤256 chars, cannot start with `-` or contain `:`) and `description`. Everything else is optional.

```markdown
---
name: reviewer
description: Reviews a diff for correctness, security, project invariants, and checkpoint compliance. Use after implementation and before asking the user to commit.
tools: Read, Grep, Glob, Bash
disallowedTools: Edit, Write, NotebookEdit
model: opus
---
Read `.agent/agents/reviewer.md` and `.agent/rules/checkpoints.md` before doing anything, and follow them. They are the source of truth; this file only wires the role into Claude Code.
```

**Tier → model**: `strong` → `opus`, `default` → `sonnet`, `cheap` → `haiku`. Available aliases are `opus`, `sonnet`, `haiku`, `fable`, plus `inherit` and full model IDs. Use `inherit` throughout when the user prefers one model everywhere.

**Tools.** Writing roles omit `tools` so they inherit everything. Read-only roles (planner, reviewer, investigator, evaluator when only reading) get `tools: Read, Grep, Glob, Bash` — Bash stays because they need to run tests and git read commands.

Bash is a write vector, so for read-only roles also set `disallowedTools: Edit, Write, NotebookEdit`. That is a real guard; the checkpoints file is only an instruction, and an instruction is not a permission boundary. Do not rely on the checkpoints file alone where a field can enforce it.

**Keep descriptions short.** All subagent descriptions share one ~15,000-token budget, so a verbose description on six roles costs the main thread. One or two sentences: what it does, when to delegate to it.

**Other optional fields**, worth knowing but not written by default: `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `omitClaudeMd`, `effort` (`low`|`medium`|`high`|`xhigh`|`max`), `isolation: worktree`, `color`, `initialPrompt`. Add one only when the user asks for the behaviour it controls. `effort` is the closest Claude Code analogue to Codex's reasoning effort, so if the user wants tiers expressed as effort rather than model, map `strong` → `high`, `default` → `medium`.

## Codex — `.codex/agents/<role>.toml`

One TOML file per agent, in `.codex/agents/` (project) or `~/.codex/agents/` (personal). Write the project one.

Required: `name`, `description`, `developer_instructions`. Optional: any supported `config.toml` key, including `model`, `model_reasoning_effort`, `sandbox_mode`, `mcp_servers`, and `skills.config`.

```toml
name = "reviewer"
description = "Reviews a diff for correctness, security, project invariants, and checkpoint compliance. Use after implementation and before asking the user to commit."
model_reasoning_effort = "high"
sandbox_mode = "read-only"
developer_instructions = """
Read .agent/agents/reviewer.md and .agent/rules/checkpoints.md before doing anything, and follow them.
They are the source of truth; this file only wires the role into Codex.
"""
```

**Tier → settings.** Do not hardcode Codex model IDs: they change often and depend on the user's access. Omit `model` so the agent inherits the session's model and effort, and express tier through `model_reasoning_effort` instead: `strong` → `"high"`, `default` → `"medium"`, `cheap` → `"low"`. Supported values are `"low"`, `"medium"`, `"high"`, `"xhigh"`, `"max"`, and `"ultra"`, but support is model-dependent — stay with high/medium/low unless the user says their model takes more.

If the user runs Codex at high effort by default (check `~/.codex/config.toml`), map `default` → `"high"` and `cheap` → `"medium"`, and say so in the report. If their config pins a model they use for everything, mention it; only add a per-agent `model` when they ask.

**Sandbox.** `sandbox_mode` takes `"read-only"` or `"workspace-write"`, and inherits the parent's when omitted. Read-only roles → `"read-only"`; writing roles → omit.

**Name collisions.** Codex ships built-in agents named `default`, `worker`, and `explorer`. The v2 role names do not collide, which is one reason not to rename `investigator` to `explorer` even though the jobs are similar.

**Dispatch.** Codex spawns subagents from natural-language prompts ("spawn the reviewer"), when asked directly, or when AGENTS.md or a skill tells it to. That is why the generated AGENTS.md includes a Delegation section naming when to spawn which role.

## Any other tool

Tools that read `AGENTS.md` (Cursor, Gemini CLI, OpenCode, Copilot, and others) get the workflow through it without adapters. Add a tool-specific adapter only when the user names the tool and you have checked its current agent format. The role doc stays the same.

## Delegation section for AGENTS.md

Generate a short block like this, listing only installed roles:

```markdown
## Delegation
When subagents are available, delegate bounded work and ask each to return a summary, not raw output:
- Before a non-trivial change: spawn `planner`.
- Broad search or log reading: spawn `investigator` (read-only, can run in parallel).
- After implementation: spawn `tester`, then `reviewer`. Review must pass before you ask to commit.
Without subagents, work through the same roles in order yourself, reading each role doc as you reach that step.
```
