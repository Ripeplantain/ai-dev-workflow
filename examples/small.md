# Example: small repo

An illustrative install on a small repo, showing how little gets written. The repo is hypothetical.

## The repo

`csvtidy`, a Python command-line tool that cleans CSV files.

```text
csvtidy/
├── README.md            usage, install, and a "Development" section
├── pyproject.toml       ruff and pytest configured; one console script
├── src/csvtidy/         cli.py, rules.py, io.py
└── tests/               test_rules.py, test_cli.py
```

## What the scan returned

```text
repo: csvtidy
file_count: 38
git: yes  git_branch: main  git_commits: 40  git_dirty_count: 0
lockfiles: uv.lock          lockfile_drift: no
stack: python pytest
ci: none
ai_signals: none
data_signals: manifests[] files[] dirs[]
agent_files: none           agent_dir: none
invariant_hints: none
wrong_case_files: none      parallel_copies: none
```

`data_signals` fired on nothing real — no pandas, no pipeline modules — so the data/AI layer stays out. This is the common case for `csvtidy`-shaped repos: the word "CSV" is not a data pipeline.

## Classification

**Size:** small — one package, one language, three modules, one contributor, no CI.
**Shape:** `cli`, `library`.

Evidence: single `pyproject.toml` with one console script; no workspace file; no CI directory.

## The plan shown

```text
agent-workflow v2.0.0 install plan: csvtidy
Classified: small · cli, library
Evidence: Python 3.11 + uv, pytest, ruff · tests: uv run pytest · CI: none

Roles (4): planner [strong] · implementer [default] · tester [default] · reviewer [strong]
Adapters: Claude Code (.claude/agents) · Codex (.codex/agents)

Will write:
  AGENTS.md                      create (no entry file existed)
  CLAUDE.md                      @AGENTS.md pointer
  .agent/PROJECT.md              stack, commands, layout, version stamp
  .agent/rules/checkpoints.md    hard stops
  .agent/rules/repo-sanity.md    rule registry is the thing agents break here
  .agent/agents/*.md             × 4
  .agent/workflows/feature.md    adding a cleaning rule
  .agent/workflows/fix.md        the only other task type here
  .claude/agents/*.md            × 4
  .codex/agents/*.toml           × 4
Total: 19 files

Skipped: investigator (three modules, nothing to investigate) · rules/engineering.md
  (role docs carry it at this size) · rules/testing.md (pytest conventions are
  obvious from two existing test files) · rules/security.md (no auth, secrets,
  or network input) · workflows/refactor.md, migration.md, release.md (no
  evidence of any) · .agent/skills/ (nothing recurring that roles do not cover)
Enforced invariants: none found
Found, not touching: nothing

Approve? (yes / edit / no)
```

## Result

```text
csvtidy/
├── AGENTS.md                     14 lines, routes into .agent/ + delegation block
├── CLAUDE.md                     1 line
├── .agent/
│   ├── PROJECT.md                34 lines
│   ├── rules/checkpoints.md      21 lines
│   ├── rules/repo-sanity.md      28 lines
│   ├── agents/planner.md         …
│   ├── agents/implementer.md
│   ├── agents/tester.md
│   ├── agents/reviewer.md
│   └── workflows/{feature,fix}.md
├── .claude/agents/*.md           4 × 6 lines
└── .codex/agents/*.toml          4 × 8 lines
```

Excerpt from the generated `PROJECT.md`:

```markdown
---
version: agent-workflow 2.0.0 (2026-10-12)
size: small
shape: cli, library
roles: planner, implementer, tester, reviewer
---

# csvtidy

Command-line tool that normalizes messy CSV files (encoding, delimiters, header
names). Published to PyPI.

## Commands
Taken from pyproject.toml and README › Development. Run nothing not listed here
without asking.

| Purpose | Command | Notes |
|---|---|---|
| install | `uv sync` | checkpoint: changes uv.lock |
| test | `uv run pytest` | |
| test one file | `uv run pytest tests/test_rules.py` | |
| lint | `uv run ruff check .` | |
| format | `uv run ruff format .` | |

## Layout
`cli.py` parses arguments and calls `io.py` to read rows, which pass through the
rule functions in `rules.py`. Each rule is a pure function from row to row,
registered in `RULES`. New cleaning behaviour is a new rule, not a change to
`cli.py`.

## Invariants
None recorded.

## Specs
`README.md` is the only spec. No ADRs.
```

Note what is absent: no restated README content, no generic engineering advice, no investigator nobody needs, no placeholder sections for things the repo does not have. The `repo-sanity.md` "look here first" table has exactly one row — `a new cleaning rule → src/csvtidy/rules.py` — because that is the one place an agent would otherwise duplicate.
