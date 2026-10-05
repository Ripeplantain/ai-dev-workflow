---
name: refactoring
description: Restructures code safely without changing behavior. Use when a requested refactor spans multiple files or a shared interface, or when code must be reshaped before a feature can be added cleanly.
---

# Specialist Skill: Refactoring

## Purpose

Change the structure of code while keeping its behavior provably the same.

## When to use

- A requested restructuring across files, modules, or a shared interface
- Preparatory reshaping that a planned feature depends on, agreed as part of that plan
- Consolidating duplicated implementations

## When NOT to use

- Opportunistic cleanup inside an unrelated task: note it and leave it
- Rewrites that change behavior: that is a feature or a migration
- Small local tidying inside code you are already changing for the task

## Procedure

1. **State the goal** concretely: what becomes easier, and how you will know it worked.
2. **Find every use.** Search for references, including strings, configuration, reflection, generated code, documentation, and consumers outside the repository.
3. **Secure a safety net.** Confirm tests cover the current behavior. If not, write characterization tests that pin what the code does now, including its quirks.
4. **Plan small steps.** Each leaves the code compiling and passing. Order them so risky steps are isolated.
5. **Apply one kind of transformation at a time:** rename, move, extract, inline, change signature. Use the language's or editor's automated refactoring where available.
6. **Run the tests after every step.** A failure means the last step changed behavior: revert it and take a smaller step.
7. **Migrate callers fully,** then delete the old path. Do not leave two implementations or a compatibility shim without an agreed reason and end date.
8. **Stop at the goal.** Record further improvements as follow-ups.

Keep behavior changes out. A bug found on the way is reported and fixed in a separate change.

## Verification

- The test suite passes unchanged, apart from tests that pinned the structure itself.
- Public interfaces, outputs, and performance characteristics are the same unless the plan said otherwise.
- No dead code, unused exports, or stale references remain.

## Expected output

What was restructured and why, the steps taken, evidence that behavior is unchanged, callers migrated, anything left for a follow-up.
