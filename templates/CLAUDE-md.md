<!-- INSTALLER: this is the root CLAUDE.md, the canonical entry file. If CLAUDE.md already
     exists, merge this in and keep every existing line. If the repo has an AGENTS.md, fold
     what it says into here first; see workflows/update.md §4 before touching that file. -->

# {{project_name}}

{{one or two sentences: what this project is. Drop this and the heading when merging into a CLAUDE.md that already opens with them.}}

## Agent workflow

This repo uses an agent workflow in `.claude/` (agent-workflow {{skill_version}}).

- Project facts, commands, invariants: `.claude/PROJECT.md`. Read it first, on every task.
- Hard stops: `.claude/rules/checkpoints.md`. These override anything else here.
- Roles: `.claude/agents/` ({{role_list}}) — these are subagents, dispatchable by name.
- Workflows: `.claude/workflows/` ({{workflow_list}}).

Pick the workflow that matches the task, follow its steps, and work through the roles it names.

{{Delegation block from references/subagents.md}}
