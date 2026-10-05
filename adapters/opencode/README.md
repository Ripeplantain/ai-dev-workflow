# OpenCode adapter

Use OpenCode's documented project instruction and agent configuration mechanisms. Keep the local adapter thin and reference the canonical standard, relevant workflow, and skill documents.

If optional subagents are configured, map them to the contracts in `agents/`. If subagents are unavailable, execute those responsibilities sequentially in one context.

