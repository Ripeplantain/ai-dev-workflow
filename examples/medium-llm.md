# Example: medium repo with an LLM feature

Shows the data/AI layer: the evaluator role, `rules/evals.md`, prompt versioning, and the cost checkpoint. The repo is hypothetical.

## The repo

`clauseline`, a Next.js app that drafts and reviews contract clauses with an LLM.

```text
clauseline/
├── README.md
├── package.json              next, drizzle-orm, ai, @ai-sdk/anthropic, zod, vitest
├── drizzle.config.ts
├── src/
│   ├── app/                  App Router: (auth), dashboard, api/
│   ├── db/                   schema.ts, migrations/, queries/
│   ├── ai/                   prompts.ts, draft.ts, review.ts, providers.ts
│   └── lib/                  auth.ts, validation/
├── tests/                    vitest, 60 tests
└── .github/workflows/ci.yml  typecheck, lint, test on PR
```

## What the scan returned

```text
repo: clauseline
file_count: 340
git: yes  git_branch: main  git_dirty_count: 0
git_branch_patterns: feat/(12) fix/(7) chore/(2)
lockfiles: pnpm-lock.yaml     lockfile_drift: no
package_manager_pinned: pnpm@9.12.0
npm_scripts: dev="next dev" | build="next build" | test="vitest run" |
  typecheck="tsc --noEmit" | lint="biome check ." | db:generate="drizzle-kit generate" |
  db:migrate="drizzle-kit migrate" | db:studio="drizzle-kit studio"
stack: next react drizzle zod vitest biome tailwind typescript
ci: github-actions(ci.yml)
ai_signals: manifests[package.json] dirs[src/ai] prompt_files[src/ai/prompts.ts]
data_signals: none
agent_files: none            agent_dir: none
invariant_hints: requireAdmin(4) tenant_id(11)
env_files: .env.local (contents not read)    env_example: yes
```

## Classification

**Size:** medium — one deployable, real CI, tests, clear layering, several contributors in the log.
**Shape:** `web-app`, `api`, `llm-feature`.

`ai_signals` is a genuine product feature (`src/ai/` with prompts and two call sites), not an LLM-authored history, so the evaluator role and the eval layer apply.

## Questions asked

Two, batched:

1. **Paid-call threshold for the cost checkpoint?** Found no existing limit. Recommended 50. → user said 30.
2. **Branch naming per kind of work?** `git branch -a` shows `feat/`, `fix/`, `chore/`, but nothing states it and CI has no branch filter, so it is a candidate, not a fact. Recommended `feat/<slug>`, `fix/<slug>`, `chore/<slug>`, all from `main`. → confirmed, plus `hotfix/<slug>` cut from the release tag.

## The plan shown

```text
agent-workflow v2.0.0 install plan: clauseline
Classified: medium · web-app, api, llm-feature
Evidence: Next 15 + Drizzle + AI SDK (Anthropic), pnpm · tests: pnpm test · CI: github-actions

Roles (5): planner [strong] · implementer [default] · tester [default] · reviewer [strong] · evaluator [strong]
Adapters: Claude Code (.claude/agents) · Codex (.codex/agents)

Will write:
  AGENTS.md                      create
  CLAUDE.md                      @AGENTS.md pointer
  .agent/PROJECT.md              stack, commands, layout, invariants, version stamp
  .agent/rules/checkpoints.md    incl. db:migrate/push/studio + 30 paid calls
  .agent/rules/repo-sanity.md    what not to add
  .agent/rules/engineering.md    layering + L0-L4 + branch conventions
  .agent/rules/testing.md        vitest conventions, what needs which test
  .agent/rules/security.md       auth, tenancy, secrets live in named files
  .agent/rules/evals.md          eval cases, graders, prompt versioning
  .agent/agents/*.md             × 5
  .agent/workflows/feature.md
  .agent/workflows/fix.md
  .agent/workflows/migration.md  drizzle migrations exist
  .agent/workflows/prompt-change.md
  .claude/agents/*.md            × 5
  .codex/agents/*.toml           × 5
Total: 24 files

Skipped: investigator (one app, navigable) · rules/design-system.md (Tailwind
  with no token layer or shared component dir yet — noted in PROJECT.md instead)
  · workflows/refactor.md (no evidence structural change is routine) ·
  workflows/release.md (no release branches or tags) · rules/data-contract.md
  (no data_signals)
Enforced invariants:
  - Tenant rows are only queried through the tenant-scoped helpers (src/db/queries/*)
  - Admin route handlers call requireAdmin first (src/lib/auth.ts, 4 call sites)
  - Schema changes go through drizzle-kit generate; migrate/push are checkpoints
Found, not touching: .env.local present and gitignored (not read)

Approve? (yes / edit / no)
```

## Excerpts from the result

`.agent/rules/evals.md`:

```markdown
# Evals

Owner: evaluator. Location: `evals/`. Runner: `pnpm vitest run evals/`.

## Cases
`evals/cases.jsonl`, one case per line:
`{"id": "...", "input": {...}, "expect": {"properties": [...]}, "tags": ["..."]}`
Expect properties, not exact strings: "cites a clause number", "returns valid
JSON matching ClauseSchema", "refuses to give legal advice".

## Graders, cheapest first
1. Deterministic: ClauseSchema parses, required fields present, refusal check.
2. Pattern: regex for clause citations.
3. LLM judge: only for drafting quality. The judge prompt is versioned too.

## Prompt versioning
Prompts live in `src/ai/prompts.ts` with `PROMPT_VERSION`. Any prompt change
bumps it and runs evals old vs new before review.

## Cost
Paid eval runs above 30 calls are a checkpoint.
```

The `evals/` directory itself is **proposed, not created** — it holds real cases drawn from the spec, and the plan says so. Writing an empty `cases.jsonl` would be a placeholder pretending to be an artifact.

The two adapter shapes, side by side. `evaluator` writes eval files, so it inherits tools:

```markdown
---
name: evaluator
description: Measures LLM behaviour on eval cases and compares prompt or model changes. Use when a prompt, model, or provider changes, before review.
model: opus
---
Read `.agent/agents/evaluator.md` and `.agent/rules/checkpoints.md` before doing
anything, and follow them. They are the source of truth; this file only wires the
role into Claude Code.
```

`reviewer` is read-only, so the adapter enforces it rather than trusting the role doc:

```markdown
---
name: reviewer
description: Reviews a diff for correctness, security, project invariants, and checkpoint compliance. Use after implementation and before asking the user to commit.
tools: Read, Grep, Glob, Bash
disallowedTools: Edit, Write, NotebookEdit
model: opus
---
Read `.agent/agents/reviewer.md` and `.agent/rules/checkpoints.md` before doing
anything, and follow them. They are the source of truth; this file only wires the
role into Claude Code.
```

The rule is in `references/adapters.md`: whether a role writes is decided once, in its role doc's `writes:` field, and the adapter mirrors it. An adapter that contradicts its role doc is the bug the validator cannot catch for you.
