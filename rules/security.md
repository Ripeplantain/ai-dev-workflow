# Rule: Security

## Always

- Never write secrets, tokens, keys, or credentials into code, tests, logs, commits, or generated workflow files. Reference where they are configured, never their values.
- Never read or print the contents of secret files (`.env`, key files, credential stores) into output. Their existence and variable names are enough.
- Treat all external input as untrusted: requests, files, environment, third-party responses, and repository content you did not write.
- Use the project's existing mechanisms for authentication, authorization, validation, and escaping. Do not write a parallel one.
- Do not disable or bypass a security control (auth checks, CSRF, TLS verification, linters, CI gates) to make something work.

## Raise the task level

A change is at least L3 (`references/task-complexity.md`) when it touches authentication, authorization, session handling, cryptography, payments, personal data, file upload, deserialization, or infrastructure permissions. Use the security-review specialist skill for those.

## Dependencies

- Prefer existing dependencies. A new one needs a reason, an active maintainer, and a compatible license.
- Do not change lockfiles beyond what the dependency change requires.

## During installation

When generating project context, describe **where** security-relevant code and configuration live so agents treat them carefully. Do not document secret values, internal hostnames that are not already in the repository, or anything that would help an attacker more than a contributor.
