# Reference: Task Complexity

Every task follows the same lifecycle. The level decides how much of each phase it gets.

```text
DISCOVER → UNDERSTAND → CLASSIFY → PLAN → IMPLEMENT → VERIFY → REVIEW → CLEAN → REPORT
```

## Levels

| Level | Meaning | Examples |
|---|---|---|
| L0 | Trivial | Typo, formatting, comment, copy change |
| L1 | Small | Localized bug, small config change, one-function addition |
| L2 | Standard | A normal feature or fix within one module |
| L3 | Significant | Cross-module change, migration, authentication change, public API change |
| L4 | Critical or architectural | Architecture change, payments, authorization redesign, major breaking change |

## What each level requires

| | L0 | L1 | L2 | L3 | L4 |
|---|---|---|---|---|---|
| Investigation | Read the line | Read the function and callers | Read the feature and a comparable one | Map all affected modules and consumers | Full investigation, written up |
| Plan | None | One sentence | Short list | Written, with risks and rollback, agreed first | Written design with alternatives, agreed first |
| Tests | None | Regression or unit test | Tests for new behavior and edges | Plus integration and failure paths | Plus rollout and rollback verification |
| Checks | Formatter or linter | Affected tests | Full standard checks | Full checks, manual exercise | Full checks, staged validation |
| Review | Glance at diff | Self-review | Self-review as a separate pass | Independent review | Independent review plus owner sign-off |
| Specialists | None | As needed | As needed | Expected for the domain touched | Required for the domain touched |
| Documentation | None | None | Update affected docs | Update docs, note the decision | Decision record |

## Classifying

Start from the size of the change, then raise the level for risk.

Raise by at least one level when the task touches:

- Authentication, authorization, sessions, secrets, or cryptography
- Money, billing, or irreversible operations
- Stored data shape, data migration, or deletion
- A public contract: API, event schema, library interface, CLI flags
- Shared code used across modules or workspaces
- Code with no tests, or an area nobody on the task understands

Lower the ceremony, never the care: an L0 change still has to be correct.

## Reclassify when reality differs

If an L1 fix turns out to need a schema change, stop and reclassify as L3 before continuing. Report the change of level and why.

## Roles by level

Where a project defines agent roles, typical involvement is:

| Level | Roles |
|---|---|
| L0, L1 | Implementer |
| L2 | Planner (brief), implementer, tester, reviewer |
| L3, L4 | Investigator, planner, implementer, tester, reviewer |

One agent may carry several roles in sequence. What matters is that review is a separate pass from implementation.
