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
agent-workflow v3.0.0 install plan: csvtidy
Classified: small · cli, library
Evidence: Python 3.11 + uv, pytest, ruff · tests: uv run pytest · CI: none

Roles (4): planner [opus] · implementer [sonnet] · tester [sonnet] · reviewer [opus]

Will write:
  CLAUDE.md                      create (no entry file existed)
  .claude/PROJECT.md             stack, commands, layout, version stamp
  .claude/rules/checkpoints.md   hard stops
  .claude/rules/repo-sanity.md   rule registry is the thing agents break here
  .claude/agents/*.md            × 4  (subagents)
  .claude/workflows/feature.md   adding a cleaning rule
  .claude/workflows/fix.md       the only other task type here
Total: 9 files

Skipped: investigator (three modules, nothing to investigate) · rules/engineering.md
  (role docs carry it at this size) · rules/testing.md (pytest conventions are
  obvious from two existing test files) · rules/security.md (no auth, secrets,
  or network input) · workflows/refactor.md, migration.md, release.md (no
  evidence of any) · specialist procedure (nothing recurring roles do not cover)
Enforced invariants: none found
Leaving alone: nothing (no .claude/ existed)
Found, not touching: nothing

Approve? (yes / edit / no)
```

## Result

```text
csvtidy/
├── CLAUDE.md                     16 lines, routes into .claude/ + delegation block
└── .claude/
    ├── PROJECT.md                34 lines
    ├── rules/checkpoints.md      21 lines
    ├── rules/repo-sanity.md      28 lines
    ├── agents/planner.md         28 lines — frontmatter + role body, one file
    ├── agents/implementer.md     31 lines
    ├── agents/tester.md          26 lines
    ├── agents/reviewer.md        24 lines
    └── workflows/{feature,fix}.md
```

Excerpt from the generated `PROJECT.md`:

```markdown
---
version: agent-workflow 3.0.0 (2026-11-17)
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
