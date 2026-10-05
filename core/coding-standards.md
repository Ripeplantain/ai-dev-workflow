# Coding Standards

Apply these as decisions during implementation, not as a reason to rewrite unrelated code.

- Prefer names that explain domain intent and match local conventions.
- Keep functions and modules cohesive; reduce coupling at real boundaries.
- Validate untrusted input at the boundary and preserve useful error context.
- Handle expected failures explicitly; do not swallow errors or expose sensitive details.
- Preserve API and data compatibility unless a breaking change is intentional and documented.
- Keep configuration externalized, typed or validated where the repository supports it, and free of secrets.
- Add logs and metrics at meaningful operational boundaries, without sensitive values.
- Use comments for decisions, invariants, or non-obvious constraints—not for restating code.
- Avoid premature abstraction and optimization; measure or identify the concrete problem first.
- Prefer established project utilities and dependencies.
- Keep changes readable and easy to test.

