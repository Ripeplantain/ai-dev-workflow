# Workflow: Update

Brings an existing `.agent/` back in line with the repository. Governed by `rules/project-installation.md`.

An update is a targeted edit, never a regeneration. Everything in `.agent/` is project-owned: people may have edited it, and those edits carry knowledge the repository does not show.

## 1. Inspect

- Run `git status`. Read every file in `.agent/` and the agent entry files that point to it.
- Check `git log` for `.agent/` to see when it was last touched, then skim what changed in the repository since: manifests, CI, top-level directories.

### Legacy `.ai/` directory

If the repository has a `.ai/` directory that holds this kind of workflow (project context, rules, agents, workflows) and no `.agent/`:

1. Confirm it is a workflow directory and not something unrelated that happens to share the name.
2. Move it with `git mv .ai .agent` so history is kept.
3. Update references to `.ai/` inside the moved files and in the entry files.
4. Continue with the steps below.

If both exist, treat `.agent/` as current, merge anything still valid from `.ai/`, and ask before deleting `.ai/`.

## 2. Rediscover

Run discovery (`references/repository-discovery.md`) focused on what `.agent/` claims and on what changed. Reclassify the repository; projects grow, split, and occasionally shrink.

## 3. Audit every claim

For each statement in `.agent/`, decide:

| Finding | Action |
|---|---|
| Still true | Leave it exactly as it is |
| Stale (command renamed, path moved, tool replaced) | Correct it in place |
| Refers to something that no longer exists | Remove it |
| Project-specific and not checkable from the code (team decisions, preferences) | Keep it |
| Contradicts the code and looks deliberate | Keep it, flag it in the report, ask if it matters |
| Generic filler that applies to any repository | Remove or specialize it |
| Leftover placeholder or installer note | Resolve it |

## 4. Find the gaps

Compare the current repository against `rules/project-installation.md`:

- New topology or technology with no coverage (a UI was added, a database arrived, the repository became a workspace).
- Artifacts that no longer pass the necessity test (an agent nobody needs, a rule file duplicated by new project docs). Removing is a valid update.
- Structure that no longer fits the complexity (a small project that outgrew single-file `RULES.md` and `WORKFLOW.md`, or the reverse).

Load templates and references only for the artifacts you are adding.

Before applying, ask the user about anything the audit and the gaps left open, following the Questions section of `SKILL.md`: claims that contradict the code and look deliberate, artifacts you would remove, and restructuring. Ask once, with your recommendation for each.

## 5. Apply

- Edit surgically. Preserve wording, ordering, and formatting of content you are not correcting.
- When restructuring (for example splitting `RULES.md` into `rules/`), move content rather than rewriting it, and update every reference.
- Keep the entry pointer correct.

## 6. Validate, review, report

Same as steps 10 to 12 of `workflows/install.md`. In the report, list each correction with what was wrong, and list separately anything you kept despite doubt.

If the audit finds nothing to change, say so. An update with an empty diff is a valid result.
