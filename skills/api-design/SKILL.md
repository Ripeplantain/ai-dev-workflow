# API Design Skill

## Purpose

Design or extend an API that fits existing conventions and remains safe to consume.

## Use when

Adding or changing HTTP, RPC, event, CLI, library, or internal service contracts.

## Do not use when

The task only changes an internal implementation with no contract impact.

## Procedure

1. Discover transport, naming, versioning, error, auth, validation, pagination, and documentation conventions.
2. Identify consumers and compatibility requirements.
3. Define request/response or message shapes, validation, authorization, failure semantics, idempotency, and observability.
4. Reuse existing schemas, serializers, middleware, and error types.
5. Plan compatibility, rollout, deprecation, and migration if the contract changes.
6. Implement focused tests for success, invalid input, unauthorized access, errors, and compatibility.

## Verification

Run contract, integration, type, security, and relevant end-to-end checks. Confirm sensitive data is absent from errors and logs.

## Expected output

Contract summary, compatibility decision, implementation scope, verification evidence, and consumer/rollout notes.

