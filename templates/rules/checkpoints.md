# Checkpoints

Stop and ask before any of these. State what you are about to do, the exact command, and why. Wait for an explicit yes. A yes covers that one action, not the category.

## Always
- `git commit`, `git push`, merge, rebase onto a shared branch, opening or updating a PR
- schema-touching commands: {{project's db commands, e.g. db:migrate, db:push, db:studio}}{{, and build if it runs migrations}}
- installing, removing, or upgrading dependencies; editing any lockfile
- reading, printing, or editing real env/secret files (`.env`, `.env.*` except `.env.example`, key files)
- deleting files you did not create in this task; deleting or overwriting data
- anything against shared, staging, or production data or services
- deploys, and edits to CI/CD config ({{CI files found}})
- paid API calls expected to exceed {{N, default 50}} in one command

## Never
- add `Co-Authored-By`, "Generated with", or any attribution trailer to commits, PRs, or files
- create parallel copies of code (`*-v2`, `*-new`, `*-old`, `copy of`); change the original instead
- leave work you started uncommitted without saying so in your final report

## Within a task (no need to ask)
Reading code, running typecheck/lint/tests/evals that are free and local, editing source files in scope, creating new files in scope, and moving between roles in the chain planner → implementer → tester → reviewer.
{{project-specific additions, e.g. tenancy or release-branch rules}}
