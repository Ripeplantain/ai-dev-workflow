# Update mode

Audit an existing install and make targeted corrections. Never regenerate from scratch: the user and their team may have edited these files by hand, and those edits are the most valuable thing in them.

## 1. Identify what is installed

- Read `.claude/PROJECT.md` for a `version:` line. Present → compare with this skill's version (3.0.0).
- No `.claude/PROJECT.md`? Look for an earlier layout before concluding nothing is installed:

| Found | Is | Go to |
|---|---|---|
| `.agent/PROJECT.md` with a `version: agent-workflow 2.x` stamp | **v2** — neutral workflow plus adapters | §4 |
| `.agent/` with no version stamp (`RULES.md`/`WORKFLOW.md`, or `rules/`+`workflows/`, `agents/`, maybe `skills/`, `context/`) | **v1** | §4, after the v1→v2 shape fixes below |
| a workflow under another name (`.agents/`, `.ai/`, `docs/ai/`) | **legacy, relocated** | §3 of this file, then §4 |
| `.claude/` holding only `settings.json`, `skills/`, or `commands/` | Claude Code configured, no workflow | `workflows/install.md` |

- Run `scripts/scan_repo.sh` and `scripts/validate.sh` to get the current problems list. Against a pre-v3 layout, pass the old directory as the second argument: `scripts/validate.sh <root> .agent`.
- `git log --oneline -- .claude .agent CLAUDE.md AGENTS.md` shows what was hand-edited since install. Treat any file changed after the install commit as user-owned: propose edits as a diff, never rewrite.

## 2. Audit

Check each, and collect findings:

1. **Drift from the repo.** Commands in `PROJECT.md` still exist in `package.json`/`Makefile`? Paths still exist? New apps, packages, or pipelines not covered?
2. **Structural rules.** One workflow dir, exact-case filenames, no second canonical entry file, no placeholders or `INSTALLER:` notes, budgets respected.
3. **Missing v3 parts.** `rules/checkpoints.md`, `rules/repo-sanity.md`, role docs with valid subagent frontmatter (`name`, `description`, `model`), version stamp, data/AI layer where `ai_signals`/`data_signals` are present.
4. **Claude Code's own files.** `.claude/settings.json`, `skills/`, `commands/`, `hooks/`, and any subagent this skill did not write belong to the user. Report problems you see in them; change nothing (SKILL.md › Writing inside `.claude/`).
5. **Layout variants.** Custom names (`specialists/` instead of `workflows/`, a workflow named `ship.md`) are allowed if they are consistent. Do not rename them just to match the template. Rename only when two conventions coexist in one repo.

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

Show findings as a plan in the install format, with each line marked `add`, `edit (diff shown on approval)`, `move`, `rename`, or `remove (needs explicit yes)`. Removing or moving a file always needs explicit approval, even with `--yes`.

Ask here about anything the audit left open, per `references/questions.md`: claims that contradict the code and look deliberate, artifacts you would remove, restructuring, and branch naming if nothing records one.

## 3. A workflow under another name

Judge by **content, not name**: a directory is a workflow directory when it holds project context, rules, agent roles, or task workflows written for agents. A directory holding only tool plumbing is **not** — installed skills (`.claude/skills/`, `.agents/skills/`), settings files, caches. Leave those alone.

Never create a second workflow directory beside one that exists; two directories are two sources of truth, and agents follow whichever they read first. Instead:

1. Treat the one you found as the workflow directory for the audit, and validate with it as the second argument.
2. Ask, with the other questions, whether to migrate it into `.claude/` (recommended — it is where Claude Code looks for subagents, so roles outside it are documentation, not agents) or adopt it in place and stop. If nobody can answer, migrate.
3. When adopting in place, keep its layout. Its files and names are the project's — a missing `PROJECT.md` is a gap to raise, not a file to add unasked. Role docs there still work as phases, but say plainly in the report that they are not dispatchable subagents until they move.

## 4. Migration into v3

The shape of v3: `CLAUDE.md` canonical, one `.claude/` directory, and one file per role at `.claude/agents/<role>.md` that is both the role doc and the subagent. Migrate with `git mv` so history follows the files, and write the `version:` stamp **last** so an interrupted migration does not claim to be complete.

**From v1**, first bring it to v2's shape: keep single-file layouts (`RULES.md`, `WORKFLOW.md`) unless the repo has outgrown them, and keep any `skills/*.md` someone wrote — v3 would not generate them (`references/selection.md`), but deleting a file someone may have edited is not an upgrade. Flag them as optional and let the user decide.

**The directory.** `git mv` each file from the old directory into the matching place under `.claude/`, then fix every reference inside the moved files and in the entry files. Remove the old directory only once it is empty. If both the old directory and a `.claude/` workflow exist, treat `.claude/` as current, report the duplicate, and ask before merging or deleting either.

**Role docs and adapters become one file.** A v2 install has the role doc at `.agent/agents/<role>.md` and a Claude Code adapter at `.claude/agents/<role>.md` whose body is a single "read the role doc" line. Fold them:

1. Keep the adapter's frontmatter — it already holds `name`, `description`, `tools`, `disallowedTools`, `model`.
2. Replace its one-line body with the role doc's body, minus the old frontmatter block.
3. Carry `tier:`, `reads:`, `writes:`, and `hands_off_to:` out of the old frontmatter into the contract lines in the body (`templates/agents/_role.md`). If there is no `model:` yet, set it from the tier: strong → `opus`, default → `sonnet`, cheap → `haiku`.
4. Delete the now-empty role doc with `git rm`.

If the role doc was hand-edited after install, its body is the user's work — move it across verbatim and say so in the report.

**`.codex/agents/`** and any other tool's adapters are no longer generated. Leave them on disk, list them in the report as orphaned by the upgrade, and remove them only on an explicit yes.

**`CLAUDE.md` becomes canonical.** A v2 `CLAUDE.md` is the single line `@AGENTS.md`. Replace it with the real content: the routing section from `templates/CLAUDE-md.md` plus anything the user had put below the import, which you keep.

**`AGENTS.md` is content, not a target.** Fold what it says into `CLAUDE.md` — hard stops into `rules/checkpoints.md` with a pointer left where they were, everything else into the routing section. Then leave the file alone. It is a convention other tools read, and deleting it is the user's call, not a step in an upgrade. Offer two options in the report and act only on an explicit yes:

- replace its body with one line pointing at `CLAUDE.md`, so there is one source of truth and other tools still find their way, or
- `git rm` it.

Either way the plan must show it, and `--yes` does not cover it.

## 5. Renaming for exact case

`claude.md` → `CLAUDE.md` needs approval and two steps on a case-insensitive filesystem:

```bash
git mv claude.md CLAUDE.tmp.md && git mv CLAUDE.tmp.md CLAUDE.md
```

One step appears to succeed and leaves the old name in the index.

## 6. Validate and report

Same as install. In the report, list hand-edited files you left alone, files left orphaned by the upgrade, and every file you propose removing but did not.

If the audit finds nothing to change, say so. An update with an empty diff is a valid result.
