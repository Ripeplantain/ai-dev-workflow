# Repository Discovery Protocol

Discovery is required before meaningful changes and should be proportional to the task level.

## Inspect

Identify, when relevant:

- repository type, languages, frameworks, package managers, and workspace systems;
- build, test, lint, format, type-check, and security commands;
- top-level directories and the architecture represented by them;
- data stores, ORM/data-access patterns, API conventions, authentication, and authorization;
- CI/CD, deployment, environment/configuration, and generated-file conventions;
- documentation, Git conventions, and existing AI instructions (`AGENTS.md`, `CLAUDE.md`, `.cursor/`, `.github/`, and equivalents).

Use repository evidence: manifests, lockfiles, scripts, CI definitions, neighboring modules, and recent history where available. Do not infer architecture from a language alone.

## Summarize before acting

For L1+ work, record a concise discovery summary:

```text
Scope: files/modules likely affected
Architecture: existing pattern to preserve
Commands: relevant verification commands and why
Constraints: local rules, compatibility, security, or deployment concerns
Unknowns: questions that could change the plan
```

Resolve high-impact unknowns before implementation. For L0, discovery may be limited to the target file and applicable instructions.

## Monorepo additions

Determine workspace boundaries, package ownership, dependency direction, shared packages, affected-project detection, and targeted build/test commands. Prefer affected verification when the repository provides a reliable mechanism. Avoid repository-wide operations when they add no confidence.

