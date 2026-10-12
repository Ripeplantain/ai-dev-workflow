# Roles

Pick 4–6. Names are fixed (so installs look alike across repos); which ones appear is tailored.

| Role | Tier | Owns | Writes code? | Include when |
|---|---|---|---|---|
| planner | strong | turning a request into a plan with acceptance checks, checking it against specs/ADRs | no (plan files only) | always |
| implementer | default | making the change, smallest defensible diff | yes | always |
| tester | default | writing/running tests, reporting failures with evidence | test files only | the repo has, or should have, tests (almost always) |
| reviewer | strong | correctness, security, invariants, checkpoint compliance on the diff | no | always |
| investigator | cheap | read-only search, tracing code paths, summarising logs | no | medium/large repos, or any repo where search output would flood the main thread |
| data-engineer | default | pipelines, data contracts, validation tiers, schema of datasets | yes (pipeline code) | `data_signals` present |
| evaluator | strong | eval sets, golden outputs, prompt version comparisons, cost per run | eval files only | `ai_signals` present (LLM feature in the product) |

Typical rosters:
- small web app: planner, implementer, tester, reviewer
- large monorepo: + investigator
- LLM product: planner, implementer, tester, reviewer, evaluator
- data pipeline: planner, data-engineer, tester, reviewer (data-engineer replaces implementer)
- LLM product with a data pipeline: planner, implementer, data-engineer, evaluator, reviewer, investigator (tester's job folds into implementer + evaluator; say so in each role doc)

Do not create: an architect separate from planner, a docs agent (the user's docs are human-written specs), or any technology-named role.

## Tiers

Tiers are abstract so role docs stay tool-neutral. Adapters map them to concrete models (`references/adapters.md`).

- **strong**: reasoning-heavy, low volume. Planning and review are where a mistake costs most.
- **default**: the main working model.
- **cheap**: fast, high-volume, read-only work.

The user runs agents at high effort and would rather spend on review than on volume; when in doubt, tier up the reviewer, not the implementer.

## Handoffs

The default chain inside one task is: planner → implementer → tester → reviewer. It runs without asking between steps, and stops at any checkpoint (`rules/checkpoints.md`). Between tasks or phases (plan approved, ready to commit, ready to ship) the main agent stops and reports.

Not every task needs the whole chain. By task level (defined in `templates/rules/engineering.md`): L0–L1 is the implementer alone; L2 adds a brief planner pass and the reviewer; L3–L4 engages every installed role, with the investigator first when the area is unfamiliar. One agent may carry several roles in sequence — what matters is that review is a separate pass from implementation, not that it runs in a separate process.

Parallelism: run read-only roles (investigator, reviewer, evaluator reading results) in parallel freely. Never run two writing roles on overlapping files at once.

What each role returns to the main agent is a summary, not raw output: findings with file:line references, commands run with pass/fail, and open questions. This keeps the main thread clean, which is the main reason to use subagents at all.
