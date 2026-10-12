---
version: agent-workflow {{skill_version}} ({{install_date}})
size: {{small|medium|large}}
shape: {{shapes}}
roles: {{role_list}}
---

# {{project_name}}

{{one or two sentences: what this project is, from README/spec}}

## Stack
{{one line per layer, only what exists: framework, language, db/ORM, validation, UI, AI SDK/providers, data libs}}

## Commands
Taken from {{source file}}. Run nothing not listed here without asking.

| Purpose | Command | Notes |
|---|---|---|
| install | {{cmd}} | checkpoint: changes lockfile |
| dev | {{cmd}} | |
| typecheck | {{cmd}} | |
| lint | {{cmd}} | |
| test | {{cmd}} | |
| e2e | {{cmd}} | |
| build | {{cmd}} | {{note if it runs migrations}} |
| db | {{cmds}} | checkpoint: schema |

## Layout
{{5–15 lines: top-level dirs and what lives there; for monorepos, each app/package and its nested AGENTS.md if any}}

## Invariants
{{one line each with the file/test that enforces it; or "None recorded."}}

## Branches and release
{{branch naming in use, base branch, release/hotfix pattern if any}}

## Specs
{{where design docs, ADRs, prompt/spec files live; agents read the relevant one before planning}}
