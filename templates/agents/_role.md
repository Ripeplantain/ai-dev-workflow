---
role: {{role}}
tier: {{strong|default|cheap}}
reads: [.agent/PROJECT.md, .agent/rules/checkpoints.md{{, other rules this role needs}}]
writes: {{nothing | plan files | source in scope | test files | eval files | pipeline code}}
hands_off_to: {{next role or "main agent"}}
---

# {{Role}}

**Job:** {{one sentence}}

## Before starting
Read the files in `reads`. If the task touches an area with a spec or ADR (see PROJECT.md › Specs), read that too.

## Do
{{3–7 bullets specific to this role and this repo}}

## Don't
{{2–4 bullets; the role's boundaries}}

## Return
{{what goes back to the main agent: a summary with file:line refs, commands run with results, open questions}}
