# Data and AI layer

Load this when the scan reports `data_signals` (pandas, polars, pyarrow, Airflow/Dagster/Prefect DAGs, dbt, `ingest`/`transform`/`validate` modules, raw data dirs) or `ai_signals` (Vercel AI SDK, openai/anthropic SDKs, OpenRouter, LangChain, prompt files, `packages/ai`).

The point is to turn rigor the user already practises by hand into generated artifacts, so each new project starts with it instead of rebuilding it.

## Data pipelines

### Data contract (`templates/rules/data-contract.md`)

Write `.agent/rules/data-contract.md` describing, from evidence:
- each input source, its expected columns/types, and allowed ranges
- **identity rules**: values that must be known for a row to be trusted (for example a plot prefix that maps to a treatment)
- the two validation tiers:
  - **halt**: identity or structural violations (unknown key, missing required column, wrong type). The run stops, because downstream joins would silently be wrong.
  - **quarantine**: value-level violations (out of range, impossible timestamp). The row goes to a quarantine output with a reason column; the run continues and logs a warning with counts.

If the repo already has a contract in code (`contract.py`, `ALLOWED_RANGES`, a schema file), the rule doc points to it and summarises it; it does not duplicate the values. The code is the source of truth.

If no contract exists, the plan offers to add one as code (a `contract` module plus a `validate` step), not only as a doc. That change goes through the normal checkpoint flow.

### Data rules

Add to `checkpoints.md` for data repos:
- never overwrite or delete raw input data; outputs go to a separate dir
- never commit data files over a size the repo already uses (check `.gitignore`), and never commit personal data
- runs against shared or production data stores are a checkpoint

### Workflow

`.agent/workflows/data-change.md`: change contract → update validation → run on a sample → compare row counts and quarantine counts before/after → reviewer checks the diff of counts, not just the code.

## LLM features

### Evals (`templates/rules/evals.md`)

Write `.agent/rules/evals.md` and propose an `evals/` directory (location by repo convention, e.g. `packages/ai/evals/`):
- `cases.jsonl`: input, expected properties (not exact strings), tags. Start with 10–20 real cases drawn from the spec, the existing tests, or the user's examples.
- a runner using the project's existing test runner (Vitest, pytest), so evals run with a script the repo already has.
- graders, cheapest first: deterministic checks (schema parses, required fields, refusal when it should refuse) → string/regex → LLM-as-judge only for what nothing cheaper can check.
- results written with the prompt version and model ID so runs are comparable.

The evaluator role owns these. Evals hitting paid APIs are a checkpoint above the threshold in `checkpoints.md`.

### Prompt versioning

Rule: prompts live in files or exported constants with a version identifier (`PROMPT_VERSION = "2026-10-12.1"` or `v3`), and a changed prompt bumps it. Eval results record the version. Do not build a prompt registry the project does not need; a constant and a changelog line are enough.

### Provider and cost

- Read how the project routes providers (for example a `providers/` dir with OpenRouter and DeepSeek). Record it in `PROJECT.md`. Agents must not add a provider or change routing without the planner noting it.
- Cost checkpoint: any command expected to make more than N paid calls stops for approval. Ask the user for N during install; default 50.
- Keys: only `.env.example` is readable. Real `.env*` files are never read or printed.

### Workflow

`.agent/workflows/prompt-change.md`: bump version → run evals on old and new → evaluator compares pass rate, failures, and cost → reviewer approves → checkpoint.
