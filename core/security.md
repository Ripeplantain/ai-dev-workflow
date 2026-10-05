# Security

Increase scrutiny for authentication, authorization, payments, personal data, secrets, infrastructure, filesystem, and network changes.

- Never commit credentials, tokens, private keys, or secret values; inspect diffs and generated files.
- Keep secrets in the repository's supported secret/configuration mechanism.
- Authenticate and authorize every protected operation; do not rely on UI visibility.
- Validate input at trust boundaries and encode output for its destination.
- Use parameterized database access and safe migrations; never concatenate untrusted SQL.
- Treat dependencies and generated code as supply-chain inputs; review provenance and permissions.
- Avoid sensitive data in logs, errors, telemetry, URLs, and test fixtures.
- Constrain filesystem and network access to the minimum required scope.
- Use least privilege for identities, services, jobs, and deployment credentials.
- Treat generated code as untrusted until reviewed and tested.

For L3/L4 security-sensitive changes, identify abuse cases, affected trust boundaries, compatibility/rollback concerns, and any required specialist review.

