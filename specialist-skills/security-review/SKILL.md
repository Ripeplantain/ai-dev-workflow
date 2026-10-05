---
name: security-review
description: Reviews a change or an area of a project for security weaknesses. Use for changes touching authentication, authorization, sessions, secrets, personal data, payments, file handling, external input parsing, or infrastructure permissions.
---

# Specialist Skill: Security Review

## Purpose

Find exploitable weaknesses in a change before it ships, and state them with enough precision to fix.

## When to use

- Any change in a security-sensitive area (see the description above)
- New external input: endpoints, uploads, webhooks, parsers, message consumers
- New dependencies or infrastructure permissions
- Before releasing an L3 or L4 change

## When NOT to use

- Changes with no trust boundary, sensitive data, or privilege involved
- As a substitute for normal code review, which still happens

## Procedure

1. **Establish the context.** What the change does, what data and privileges it touches, and the project's existing security mechanisms.
2. **Map trust boundaries.** Where does untrusted input enter, and where does it end up: queries, commands, file paths, templates, outbound requests, logs, deserializers?
3. **Check access control.** Every new or changed operation authenticates, then authorizes for the specific resource, on the server side. Look for missing ownership checks and privilege escalation paths.
4. **Check input handling.** Validation at the boundary, parameterized queries, safe file and path handling, output encoding, limits on size and rate. Trace each input to each sink.
5. **Check secrets and data.** Nothing sensitive in code, logs, errors, URLs, or client-visible responses. Stored and transmitted according to the project's practice.
6. **Check state and sessions.** Token handling, expiry, cross-site request protections, and race conditions in check-then-act sequences.
7. **Check dependencies and configuration.** New packages, changed permissions, opened network paths, disabled protections, debug settings.
8. **Assess each finding.** How it would be exploited, by whom, and with what impact. Discard anything you cannot describe a concrete path for.

## Verification

- Each finding is confirmed against the code path, not inferred from a pattern match.
- Where safe, demonstrate with a test at the request level; never against shared or production systems.
- After fixes, re-check the specific path and add a regression test.

## Expected output

Findings ordered by severity, each with location, exploit scenario, impact, and a specific fix. Then what was reviewed, what was out of scope, and any assumption the conclusion depends on. "No findings" is a valid result when stated with its scope.
