# Testing and Verification

Verification must reflect the repository's actual commands and the change's risk.

## Discover commands

Read manifests, scripts, CI configuration, and contributor documentation. Do not assume a package manager, test runner, or build command.

## Proportional checks

- L0: targeted syntax, formatter, or focused check when available.
- L1: affected unit/integration tests plus relevant lint/type checks.
- L2: affected tests, lint/type checks, and build/package checks where applicable.
- L3: broader dependency-aware tests, migration validation, and explicit review.
- L4: comprehensive verification, security checks, rollout/rollback validation, and decision documentation.

Prefer affected-project checks in monorepos when reliable. Add regression tests for bug fixes and behavior changes when the repository's testing style supports them.

## Reporting

Report the exact commands run and their outcomes. Distinguish passed, failed, skipped, and unavailable checks. Never convert an unrun check into a claim of success.

