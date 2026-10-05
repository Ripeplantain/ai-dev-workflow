---
name: api-design
description: Designs or changes an interface that other code consumes, consistent with the project's existing API. Use when adding or altering HTTP endpoints, GraphQL or RPC schemas, event contracts, library public interfaces, or CLI commands and flags.
---

# Specialist Skill: API Design

## Purpose

Add or change a consumed interface so that it is consistent with what exists, hard to misuse, and does not break its consumers.

## When to use

- New endpoints, operations, events, public functions, or CLI commands
- Changes to an existing contract: fields, types, status codes, errors, defaults
- Versioning or deprecation decisions

## When NOT to use

- Internal functions with no consumers outside their module
- Implementing an endpoint whose contract is already specified: follow the feature workflow

## Procedure

1. **Learn the existing API.** Naming, resource and URL structure, request and response shapes, error format, status code usage, pagination, filtering, authentication, versioning, and where the contract is defined (schema files, types, documentation). Read three comparable operations.
2. **Identify the consumers.** Who calls this, and can they all be changed and deployed together? If not, the contract is public and compatibility rules apply.
3. **Design from the consumer's side.** What they need to send and receive for their use case, in the project's existing vocabulary.
4. **Stay consistent.** Follow the existing conventions even where you would choose differently. A second convention costs more than an imperfect first one.
5. **Define failure.** Validation errors, not found, unauthorized, conflict, and partial failure, in the project's error shape.
6. **Check compatibility.** Adding optional things is usually safe. Removing, renaming, retyping, tightening validation, or changing defaults breaks consumers. For a breaking change use the project's versioning and deprecation process.
7. **Cover the edges.** Authorization per operation, idempotency for retried writes, limits on list sizes and payloads.
8. **Update the contract artifacts** the project keeps: schema, generated clients, API documentation, changelog.

## Verification

- Contract tests or request-level tests cover success and each failure mode.
- Schema or type generation and validation pass.
- Existing consumers and their tests still pass; any breaking change is listed.

## Expected output

The contract (operations, shapes, errors), how it matches existing conventions, compatibility impact, consumer migration notes if any, and artifacts updated.
