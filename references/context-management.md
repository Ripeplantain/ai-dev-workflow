# Reference: Context Management

An agent's context window is a budget. Everything loaded competes with the code the agent needs to read. This applies to how the skill loads itself and to what it writes into `.agent/`.

## Loading the skill

- Load `SKILL.md`, then the workflow for the mode, then only what each step calls for. The table in `SKILL.md` is the map.
- Decide what applies before loading it. Finding no UI code means the design-system files are never opened.
- Load a template when you are about to write that artifact, not before.
- Load specialist skills one at a time, when the task reaches the point of needing them.

## Reading a target repository

- Start with listings and manifests. Open source files only to confirm a specific question.
- Search for a symbol or pattern rather than reading directories file by file.
- Read part of a large file when you know the part you need.
- Skip dependencies, build output, lockfile bodies, generated code, fixtures, and binary assets.
- Write a fact down once you have confirmed it and stop re-reading its source.
- In large repositories, sample: one representative module per kind, not every module.

## Writing `.agent/`

What you generate will be loaded on future tasks, so its size is a recurring cost.

- `PROJECT.md` is the one file every task loads. Keep it short and factual, and make it the index to everything else.
- Each other file should be loadable alone and only when relevant: a rule file for its topic, a workflow for its task type, a context file for its area.
- State in `PROJECT.md` when each file should be read, so agents do not load all of them.
- Link to existing documentation instead of copying it.
- Prefer exact commands, paths, and names over prose.
- Cut anything an agent would do correctly without being told.

## Long tasks

- Summarize findings before moving from investigation to implementation, and work from the summary.
- Delegate broad searches to a subagent when the environment supports it, and take back only the conclusion.
- Keep track of decisions and remaining steps in your working notes so they survive context compaction.
