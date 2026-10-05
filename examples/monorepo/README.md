# Monorepo example

```text
AGENTS.md
apps/web/AGENTS.md
services/api/AGENTS.md
packages/database/AGENTS.md
.ai/config.yml
```

The root file defines global safety and workflow rules. Workspace files add ownership, boundaries, commands, and local conventions. Verification should target affected workspaces first, then expand when dependency or release risk requires it.

