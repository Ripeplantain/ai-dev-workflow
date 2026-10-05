# AI Engineering Workflow — standard profile

## Operating contract

AI should adapt to this repository, not the reverse. Follow the universal lifecycle:

**Read → Understand → Classify → Plan → Implement → Verify → Review → Clean → Report**

## Before meaningful work

- Load applicable `AGENTS.md` files from root to target path.
- Inspect manifests, lockfiles, scripts, CI, neighboring code, and documentation.
- Identify architecture, module boundaries, data access, API/auth conventions, and actual verification commands.
- Classify the task L0–L4. Use deeper planning and review as risk increases.

## During work

- Preserve existing architecture and naming.
- Reuse existing implementations and dependencies.
- Make the smallest correct, cohesive change.
- Do not modify unrelated files, overwrite user changes, commit secrets, or create debug artifacts.

## Before reporting done

- Run relevant format, lint, type, test, build, and security checks proportional to the task.
- Review the diff as though you did not implement it.
- Report exact commands and outcomes, skipped checks, limitations, residual risks, and follow-ups.

For detailed guidance, load the upstream core, workflow, and skill documents relevant to the task.

