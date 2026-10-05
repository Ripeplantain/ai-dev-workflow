# Hierarchical Context

Context is layered from broad to specific:

```text
Global rules
  + repository rules
    + workspace or app rules
      + module rules
        + task context
```

More specific rules may extend or constrain broader rules. They should not silently contradict a higher-level safety rule.

## Convention

Common locations include:

```text
AGENTS.md
apps/web/AGENTS.md
apps/api/AGENTS.md
packages/database/AGENTS.md
```

Tools may use their own equivalent files. The adapter should map those files to this hierarchy rather than create a second set of engineering rules.

## Loading behavior

1. Find applicable instruction files from repository root to the target path.
2. Read the narrowest relevant scope before changing files.
3. Load module or task instructions only when the task enters that scope.
4. If rules conflict, identify the conflict and follow the more specific rule unless it weakens a global safety requirement.
5. Report important assumptions that remain unresolved.

This keeps context useful in large repositories and prevents irrelevant instructions from dominating the task.

