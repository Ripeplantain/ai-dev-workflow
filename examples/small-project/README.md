# Example: Small Project

An illustrative install on a small repository, showing how little gets generated. The repository is hypothetical.

## The repository

`csvtidy`, a Python command-line tool that cleans CSV files.

```text
csvtidy/
├── README.md            usage, install, and a "Development" section
├── pyproject.toml       ruff and pytest configured; one console script
├── src/csvtidy/         cli.py, rules.py, io.py
└── tests/               test_rules.py, test_cli.py
```

## Evidence and classification

| Fact | Source |
|---|---|
| Python 3.11, packaged with `uv` | `pyproject.toml`, `uv.lock` |
| Tests with pytest, lint and format with ruff | `pyproject.toml` |
| No CI, no database, no UI, no API | absence of any such files |
| One contributor, 40 commits, free-form messages | `git log` |
| No agent instruction files | root listing |

**Complexity:** small. **Topology:** CLI, single application.

## Decisions

| Artifact | Decision | Reason |
|---|---|---|
| `PROJECT.md` | keep | Nothing tells an agent the module roles or the verification command |
| `RULES.md` | keep | A few project-specific constraints worth stating once, including the branch and commit rules |
| `WORKFLOW.md` | skip | The README's Development section already covers the loop; `RULES.md` carries the verification step |
| `agents/` | skip | One person, three modules; roles would be ceremony |
| `rules/`, `workflows/` directories | skip | Small projects use single files |
| Security, design-system, migration, specialist skills | skip | No evidence for most; the commit rules fit in five lines of `RULES.md` |
| `AGENTS.md` (root) | create | No entry file existed; contains only the pointer |

## Result

```text
csvtidy/
├── AGENTS.md            new, 4 lines, points to .agent/PROJECT.md
└── .agent/
    ├── PROJECT.md       31 lines
    └── RULES.md         24 lines
```

Excerpt from the generated `PROJECT.md`:

```markdown
# csvtidy

Command-line tool that normalizes messy CSV files (encoding, delimiters, header names). Published to PyPI.

## Commands

| Task | Command |
|---|---|
| Install | `uv sync` |
| Test | `uv run pytest` |
| Test one file | `uv run pytest tests/test_rules.py` |
| Lint and format | `uv run ruff check . && uv run ruff format --check .` |

**Before reporting a task complete, run:** `uv run ruff check . && uv run pytest`

## Architecture

`cli.py` parses arguments and calls `io.py` to read rows, which pass through the
rule functions in `rules.py`. Each rule is a pure function from row to row,
registered in `RULES`. New cleaning behavior is a new rule, not a change to `cli.py`.

## Canonical documentation

- `README.md`: usage and the development setup
```

Note what is absent: no restated README content, no generic engineering advice, no agents, no placeholder sections for things the project does not have.
