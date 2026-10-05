# AI Engineering Workflow Standard

**Version 0.1 · specification-first · tool-agnostic**

> AI should adapt to the repository. The repository should not adapt to the AI.

AI coding tools are useful, but they often lose architectural context, invent duplicate abstractions, skip verification, modify unrelated files, or behave differently across models and products. This repository defines a small, portable engineering standard for using AI safely in real software repositories.

The canonical lifecycle is:

**Read → Understand → Classify → Plan → Implement → Verify → Review → Clean → Report**

The lifecycle is adaptive. A typo does not need the ceremony of an authorization redesign.

## What this is

- A repository-aware engineering workflow for AI-assisted changes.
- A set of reusable principles, task workflows, skills, agent contracts, templates, and examples.
- A portable source of truth that tool adapters can reference.

## What this is not

- A giant system prompt.
- A programming framework or package manager.
- A forced software architecture.
- Tied to one model, language, framework, or AI coding product.

## Quick start

Choose the smallest profile that fits the repository and copy it into the target repository:

```text
templates/minimal/   # prototypes and tiny repositories
templates/standard/  # recommended default for production applications
templates/monorepo/  # multiple apps, packages, or services
```

At minimum, copy `AGENTS.md` and `.ai/config.yml`. Then customize the repository-specific sections. Keep the core standard upstream-managed when adopting it wholesale; keep local rules and decisions project-owned.

For each meaningful task, the agent should:

1. Read the applicable global, repository, workspace, and module instructions.
2. Discover the repository before proposing a solution.
3. Classify the task from L0 to L4.
4. Load the matching workflow and relevant skills.
5. Make the smallest correct change that preserves existing architecture.
6. Run proportional verification and review the diff as an independent reviewer.
7. Report what changed, what was verified, and any limitations.

## Profiles

| Profile | Use when | Includes |
| --- | --- | --- |
| `minimal` | Tiny repositories, prototypes, personal projects | A short instruction file and lightweight config |
| `standard` | Normal production applications | Full lifecycle, context hierarchy, verification, and reporting guidance |
| `monorepo` | Multiple apps, packages, or services | Standard guidance plus workspace boundaries, ownership, and affected-project checks |

`standard` is the recommended default. Profiles are starting points, not architecture mandates.

## Repository map

```text
core/       shared engineering principles and safeguards
workflows/  task-specific lifecycle adaptations
agents/     optional planner/implementer/reviewer contracts
skills/     focused instructions loaded only when relevant
templates/  minimal, standard, and monorepo starter profiles
adapters/   thin guidance for individual AI tools
decisions/  lightweight architectural decision records
schemas/    optional validation for convention-based configuration
examples/   small adoption examples
```

The core documents are the source of truth. Workflows, skills, agents, adapters, and templates should reference the core rather than creating competing engineering philosophies.

Task-level guidance lives in [`core/task-classification.md`](core/task-classification.md); reporting expectations live in [`core/reporting.md`](core/reporting.md).

## Task levels

| Level | Typical change | Minimum shape |
| --- | --- | --- |
| L0 | Typo, formatting, obvious one-line documentation fix | Understand → Implement → Verify |
| L1 | Localized bug, small UI or validation change | Discover → Understand → Implement → Verify → Report |
| L2 | Normal feature, endpoint, component, or moderate bug | Discover → Understand → Plan → Implement → Verify → Review → Report |
| L3 | Cross-module feature, migration, auth, infrastructure, shared package | Deep plan, dependency analysis, broader tests, explicit review |
| L4 | Architecture, security-critical, payments, authorization redesign, breaking API | Decision record, staged implementation, comprehensive verification, explicit risks |

When uncertain, start one level higher, explain why, and reduce ceremony only after discovery shows it is safe.

## Tool compatibility

Adapters are deliberately thin. They explain how to make a tool load the canonical standard and repository-specific instructions; they do not pretend that every tool supports the same configuration format. See `adapters/` for Codex, Claude Code, Cursor, GitHub Copilot, Gemini, and OpenCode guidance.

## Future direction

The repository is structured for future integrations without requiring them in v0.1:

- `npx ai-dev-workflow init` could install a selected profile.
- `npx ai-dev-workflow update` could update upstream-managed files without overwriting project-owned rules.
- The same core could become a Codex skill, Claude Code integration, Cursor ruleset, OpenCode integration, or other plugin.

Future installers should clearly distinguish **upstream-managed files** from **project-owned files**. An installer must preserve local rules, decisions, and configuration extensions.

## Roadmap

- v0.1 — specification and starter templates
- v0.2 — improved tool adapters
- v0.3 — reusable skills
- v0.4 — project initialization CLI
- v0.5 — automatic repository detection
- v1.0 — stable workflow specification

These are direction-setting milestones, not release promises.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md). Changes should improve portability, reduce ambiguity, or make the workflow easier to apply without adding ceremony for its own sake.

## License

MIT. See [LICENSE](LICENSE).
