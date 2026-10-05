# Workflow: Investigation

Answers a question about the repository without changing it. Used on its own ("how does billing work?") or as the first phase of an L3 or L4 task in an unfamiliar area.

## Discover

- Write the question down precisely, and what decision the answer will inform.
- Set a boundary: which parts of the system are in scope, and how deep to go.

## Understand

- Start from an entry point (route, command, job, event) and trace toward the data.
- Prefer primary evidence: code, configuration, tests, schema, Git history. Treat comments and old docs as hints to confirm.
- Record findings as you go with file and line references. Separate what you confirmed from what you infer.
- Follow `references/context-management.md`: read narrowly, summarize, and move on.

## Stop when

- The question is answered with evidence, or
- You have hit something the repository cannot tell you (runtime configuration, external systems, intent). Name it and stop there.

## Do not

- Change code, configuration, or data.
- Leave notes, scripts, or documents in the repository unless a written artifact was requested.
- Present inference as fact.

## Report

- The answer, first.
- The evidence: the path through the code, with references.
- What is confirmed, what is inferred, and what is unknown.
- Risks or surprises found on the way.
- If this feeds a task: the recommended task level and approach.
