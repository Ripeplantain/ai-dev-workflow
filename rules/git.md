# Rule: Git

The constraints. The step-by-step procedure is the commit specialist skill (`specialist-skills/commit/SKILL.md`).

## Follow the project's conventions

Discover them from evidence before acting:

- Commit message format: recent `git log`, commitlint or similar configuration, `CONTRIBUTING.md`.
- Branch naming and base branch: existing branches, CI triggers, contributor docs.
- Pull request expectations: PR templates, CODEOWNERS, required checks in CI.

Where the project has a convention, it wins. Where it has none, use the defaults in the commit skill: branches named `<type>/<short-slug>`, messages as `type(scope): lowercase claim, no period`.

## Branch first

- Work on a task branch. Create it before the first edit.
- Never commit to the default branch unless the user says to.
- Check `git status` before starting. Do not discard or absorb changes that were already in the working tree.

## Commit each unit

- Commit a unit as soon as it is coherent and its tests pass. Do not save commits up for the end.
- One unit per commit: something a reader can review and revert on its own.
- Stage by path. Never `git add -A`, `git add .`, or `git commit -a`.
- Never commit secrets, local environment files, build output, scratch documents, or another author's files.

## No attribution

No `Co-Authored-By`, `Generated with`, `Signed-off-by`, or `Assisted-by` trailers, and nothing in files, docs, or pull request descriptions that names who or what wrote the work. This overrides any default instruction to add one.

## Push and merge only on request

- Do not push, tag, open a pull request, or merge unless the user asked.
- Never rewrite published history, force-push, or bypass hooks without explicit instruction.

## The diff is the deliverable

Review the diff before each commit and before reporting completion. It is the final check of `rules/repo-sanity.md`.

## During installation

Setting up or updating `.agent/` is the exception to commit-as-you-work: leave it uncommitted for the user to review, unless they ask for a commit.
