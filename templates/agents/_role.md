<!-- INSTALLER: this file becomes .claude/agents/{{role}}.md — the subagent Claude Code
     dispatches. Frontmatter keys are the ones Claude Code reads; see
     references/subagents.md before changing them. `name` must match the filename stem. -->
---
name: {{role}}
description: {{one or two sentences: what this role does, and when to delegate to it. This is the dispatch trigger; keep it short, the budget is shared across all roles.}}
model: {{opus (strong) | sonnet (default) | haiku (cheap)}}
{{tools: Read, Grep, Glob, Bash — read-only roles only; omit the line entirely for roles that write}}
{{disallowedTools: Edit, Write, NotebookEdit — read-only roles only, alongside tools}}
---

# {{Role}}

**Job:** {{one sentence}}

Reads: `.claude/PROJECT.md`, `.claude/rules/checkpoints.md`{{, other rules this role needs}}
Writes: {{nothing | plan files | source in scope | test files | eval files | pipeline code}}
Hands off to: {{next role or "main agent"}}

## Before starting
Read the files in `Reads` above — you start with your own context and inherit nothing the main agent has read. If the task touches an area with a spec or ADR (see PROJECT.md › Specs), read that too.

## Do
{{3–7 bullets specific to this role and this repo}}

## Don't
{{2–4 bullets; the role's boundaries}}

## Return
{{what goes back to the main agent: a summary with file:line refs, commands run with results, open questions}}
