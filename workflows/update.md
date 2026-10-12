# Update mode

Audit an existing install and make targeted corrections. Never regenerate from scratch: the user and their team may have edited these files by hand, and those edits are the most valuable thing in them.

## 1. Identify what is installed

- Read `.agent/PROJECT.md` for a `version:` line.
  - Present → compare with this skill's version (2.0.0).
  - Absent but `.agent/` exists → treat it as **v1** (the earlier ai-dev-workflow layout: `.agent/PROJECT.md`, `RULES.md`/`WORKFLOW.md` or `rules/`+`workflows/`, `agents/`, maybe `skills/` or `context/`).
- Run `scripts/scan_repo.sh` and `scripts/validate.sh` to get the current problems list.
- `git log --oneline -- .agent AGENTS.md CLAUDE.md` shows what was hand-edited since install. Treat any file changed after the install commit as user-owned: propose edits as a diff, never rewrite.

### The workflow directory may not be called `.agent/`

Before assuming, check whether the workflow lives somewhere else. Judge by **content, not name**: a directory is a workflow directory when it holds project context, rules, agent roles, or task workflows written for agents. Common places are `.agents/`, `.ai/`, and `docs/ai/`.

A directory holding only tool plumbing is **not** a workflow: installed skills (`.claude/skills/`, `.agents/skills/`), settings files, caches. Leave those alone.

When a workflow exists under another name, never create `.agent/` beside it — two workflow directories are two sources of truth, and agents follow whichever they read first. Instead:

1. Treat that directory as the workflow directory for every step below, and read each `.agent/` path in this skill as that directory.
2. Ask, with the other questions in step 3, whether to adopt it in place (recommended), move it to `.agent/` with `git mv` and fix every reference, or leave it untouched and stop. If nobody can answer, adopt in place.
3. Keep its layout. Its files, names, and structure are the project's — a missing `PROJECT.md` is a gap to raise, not a file to add unasked. Do not reshape it to match the template.
4. Write entry pointers and cross-references with the directory's real name.
5. Validate with the directory as the second argument: `scripts/validate.sh <root> <workflow-dir>`.

A legacy `.ai/` directory with no `.agent/` is the one case where moving is the default: `git mv .ai .agent`, then update references inside the moved files and in the entry files. If both exist, treat `.agent/` as current, report the duplicate, and ask before merging or deleting either.

## 2. Audit

Check each, and collect findings:

1. **Drift from the repo.** Commands in `PROJECT.md` still exist in `package.json`/`Makefile`? Paths still exist? New apps, packages, or pipelines not covered?
2. **Structural rules.** One workflow dir, exact-case filenames, `CLAUDE.md` is a pointer, no placeholders or `INSTALLER:` notes, budgets respected.
3. **Missing v2 parts.** `rules/checkpoints.md`, `rules/repo-sanity.md`, adapters, model tiers, version stamp, data/AI layer where `ai_signals`/`data_signals` are present.
4. **Layout variants.** Custom names (`specialists/` instead of `skills/`, a workflow named `ship.md`) are allowed if they are consistent. Do not rename them just to match the template. Rename only when two conventions coexist in one repo.

For each claim in the existing files, decide:

| Finding | Action |
|---|---|
| Still true | Leave it exactly as it is |
| Stale (command renamed, path moved, tool replaced) | Correct it in place |
| Refers to something that no longer exists | Propose removal |
| Project-specific and not checkable from code (team decisions, preferences) | Keep it |
| Contradicts the code and looks deliberate | Keep it, flag it, ask if it matters |
| Generic filler that applies to any repo | Propose removal, or specialize it |
| Leftover placeholder or installer note | Resolve it |

Then check for gaps against `references/selection.md`: new topology or technology with no coverage, and artifacts that no longer pass the necessity test. Removing an artifact nobody needs is a valid update.

## 3. Plan

Show findings as a plan in the install format, with each line marked `add`, `edit (diff shown on approval)`, `rename`, or `remove (needs explicit yes)`. Removing a file always needs explicit approval, even with `--yes`.

Ask here about anything the audit left open, per `references/questions.md`: claims that contradict the code and look deliberate, artifacts you would remove, restructuring, and branch naming if `.agent/` records none.

## 4. v1 → v2 migration specifics

- Keep `.agent/agents/*.md` role docs; add the v2 frontmatter fields (`tier`, `reads`, `writes`, `hands_off_to`) from `templates/agents/_role.md` without rewriting the body.
- Pull hard stops scattered in AGENTS.md or rule files into `rules/checkpoints.md`, and leave a one-line pointer where they were.
- v1 single-file layouts (`RULES.md`, `WORKFLOW.md`) are fine to keep. Split them into `rules/` and `workflows/` only if the repo has outgrown them, and then move the content rather than rewriting it, updating every reference.
- v1 `skills/*.md` copied from the old specialist-skills: keep them. v2 would not generate them (`references/selection.md`), but deleting a file someone may have edited is not an upgrade. Flag them as optional in the report and let the user decide.
- Add adapters.
- Add the `version:` stamp **last**, so an interrupted migration does not claim to be complete.

## 5. Renaming for exact case

`agents.md` → `AGENTS.md` needs approval and two steps on a case-insensitive filesystem:

```bash
git mv agents.md AGENTS.tmp.md && git mv AGENTS.tmp.md AGENTS.md
```

One step appears to succeed and leaves the old name in the index.

## 6. Validate and report

Same as install. In the report, list hand-edited files you left alone, and every file you propose removing but did not.

If the audit finds nothing to change, say so. An update with an empty diff is a valid result.
