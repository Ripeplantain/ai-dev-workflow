# Repository Sanity

AI-generated changes must leave the repository cleaner or unchanged outside their intended scope.

## Avoid

- random Markdown files, debug artifacts, temporary scripts, or dead code;
- duplicate utilities, wrappers, abstractions, or parallel implementations;
- speculative directories, dependencies, or framework layers;
- unrelated formatting, renaming, or refactoring;
- commented-out implementations and stale migration leftovers.

## Before creating a file

Ask:

1. Does something similar already exist?
2. Can the existing implementation be extended safely?
3. Is this location architecturally appropriate?
4. Is the file necessary for the requested outcome?

## Before adding a dependency

Check whether the standard library or an existing dependency is sufficient. If not, consider maintenance, security, license, bundle/runtime, and operational cost. Record the reason for a meaningful new dependency.

## Cleanup

Remove temporary files created during the task. Inspect status and diff before reporting completion. Do not delete user-owned files merely because they are unfamiliar.

