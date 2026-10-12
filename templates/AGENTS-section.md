<!-- Section added to the root AGENTS.md. If AGENTS.md already exists, append this after the existing content and keep every existing line. -->

## Agent workflow

This repo uses an agent workflow in `.agent/` (agent-workflow {{skill_version}}).

- Project facts, commands, invariants: `.agent/PROJECT.md`. Read it first.
- Hard stops: `.agent/rules/checkpoints.md`. These override anything else.
- Roles: `.agent/agents/` ({{role_list}}).
- Workflows: `.agent/workflows/` ({{workflow_list}}).

Pick the workflow that matches the task, follow its steps, and work through the roles it names.

{{Delegation block from references/adapters.md}}
