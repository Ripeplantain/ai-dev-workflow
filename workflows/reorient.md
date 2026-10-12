# Re-orient mode

For coming back to a repo after weeks or months. Read-only: it changes nothing unless the user then approves a specific action.

The user's most common real problem is work built and left uncommitted in the tree. This mode exists to make that state legible fast, and to stop agents from piling new work on top of it.

## Steps

1. Run `scripts/scan_repo.sh <root>`.
2. Git state, all read-only:
   - `git status --porcelain=v1 -b`
   - `git log -1 --format='%h %ar %s'` and `git log --oneline -10`
   - `git stash list`
   - `git branch -vv` (local branches, upstream, ahead/behind)
   - `git diff --stat` and `git diff --stat --cached`
3. Group the dirty files by area (top-level dir or package) and, for each group, read just enough of the diff to say in one line what the work is. Untracked files: list them and guess whether each is real work, a build artifact, or a stray file.
4. Can it build? Read the commands from `.agent/PROJECT.md` or `package.json` / `Makefile`. Do **not** run install, build, migrations, or anything that writes. You may run read-only checks the project defines, such as a typecheck or lint with no `--fix`, when they need no network and no install. If `node_modules` / venv is missing, say so rather than installing.
5. If `.agent/` exists, check its `version:` stamp against this skill's version and note whether update mode is due.

## Report

```
<repo> · branch <name> (<ahead/behind>) · last commit <when>: "<subject>"

Uncommitted: <N> files in <k> groups
  <group>  <n files>  <one-line description of the work>
  ...
Untracked worth keeping: <list> · likely junk: <list>
Stashes: <n> (<newest subject>)

Health: <typecheck/lint result or "not run: deps not installed">
Hygiene: <lockfile drift, wrong-case files, stale config, or "clean">
Workflow: <none | v<x> installed, update available | current>

Suggested next step: <one concrete action>
Suggested commits:
  1. <type(scope): message>  ← <group>
  2. ...
```

The suggested commits split the dirty work into reviewable chunks the user can make themselves. Do not stage or commit. If the user approves, you may stage per group and show the staged diff, then stop at the commit checkpoint.

Then offer, in one line, whichever comes next: install (no workflow), update (old workflow), or continue the task they came back for.
