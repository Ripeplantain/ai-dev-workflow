# Contributing

Thanks for helping improve the skill. It is a set of Markdown instructions read by AI agents, so every line costs context each time it is loaded. Contributions that make it shorter and sharper are as welcome as ones that add capability.

## Principles

- **The repository being set up is the authority.** Guidance must lead an agent to discover what a project does, never to impose a stack, architecture, or process.
- **Evidence over assumption.** Discovery guidance names where to look, not what to expect.
- **Proportionate output.** Nothing should push the installer toward generating more files. If a change makes small projects get more ceremony, it needs a strong reason.
- **Progressive loading.** New material goes in the file where it is needed, behind a condition in the loading table in `SKILL.md`. Keep `SKILL.md` an orchestrator.
- **Stack-agnostic.** No technology-specific agents or rules. Technology-specific detail belongs in discovery evidence tables or examples.
- **Every file justifies its existence.** Before adding one, check whether an existing file should carry the content.

## Where things go

| Change | Location |
|---|---|
| How a mode proceeds | `workflows/install.md`, `update.md`, `reorient.md` |
| What gets generated and when | `references/selection.md` |
| Detecting a tool, framework, or layout | `scripts/scan_repo.sh`, then `references/monorepos.md` or `data-ai.md` |
| What to ask the user, and how | `references/questions.md` |
| The roster, tiers, or handoffs | `references/roles.md` |
| Wiring a role into a tool | `references/adapters.md` |
| Content of generated project files | `templates/` |
| A reusable specialized procedure | `references/specialists.md` |

## Conventions

- The project-side directory is `.agent/`. Do not introduce `.ai/` except where describing migration from it.
- Template placeholders are `{{UPPER_SNAKE_CASE}}` and describe what to fill in. Guidance for the installer goes in `<!-- INSTALLER: ... -->` comments. Both must be impossible to leave behind unnoticed; the validator rejects them.
- Templates reference generated files as `.agent/...` paths. Skill files reference each other by path relative to the skill root.
- Keep the role, rule, workflow, and fact concepts distinct (see SKILL.md › Vocabulary).
- Scripts stay POSIX-ish and must run under macOS's Bash 3.2: no associative arrays, no `mapfile`, no `${var,,}`.
- Both adapter formats are documented against their vendors' current docs, with the date checked noted in `references/adapters.md`. If you change a format, re-verify it and update that date.

## Checking a change

```bash
/bin/bash -n scripts/validate.sh scripts/scan_repo.sh   # Bash 3.2 syntax
/bin/bash scripts/validate.sh --links .                 # internal links
```

Then test for real: run the skill against at least one repository of the kind your change affects, and one it should not affect, and read the resulting `.agent/` diff. Say which repositories you tried in the pull request.

## Pull requests

- One focused change per pull request.
- Add an entry under "Unreleased" in `CHANGELOG.md`.
- Explain what behavior of the installer changes, not only which text changed.
