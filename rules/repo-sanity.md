# Rule: Repository Sanity

Every file, function, and dependency added to a repository is something a person has to maintain. Add as little as correctness allows.

## Before creating anything

1. Is this necessary?
2. Does it already exist somewhere in the repository?
3. Will it actually be used?
4. Is this the correct location for it?
5. Can the same result be achieved with fewer files or less code?

Search before you create. Look for an existing utility, component, type, constant, or script that already does the job, including under a different name.

## Do not add

| Avoid | Do instead |
|---|---|
| Duplicate utilities or components | Reuse or extend the existing one |
| Wrappers that only forward a call | Call the thing directly |
| Speculative abstractions | Write the concrete case; abstract on the third real use |
| Unnecessary dependencies | Use what is already installed |
| Parallel implementations (`v2`, `new`, `-old`) | Change the existing implementation in place |
| Temporary or one-off scripts | Run the command; delete anything left behind |
| Unrequested documentation files | Update the document that already covers the topic |
| Dead code and commented-out code | Delete it; version control remembers |
| Unrelated formatting changes | Format only the lines you changed |
| Unrelated refactors | Note them for a separate change |

## Before finishing

- Read the full diff. Every changed line should trace to the task.
- Remove debug output, scratch files, stray TODOs, and unused imports you introduced.
- Confirm no generated or build output was added to version control.
- If the diff is larger than the task suggests, explain why or shrink it.
