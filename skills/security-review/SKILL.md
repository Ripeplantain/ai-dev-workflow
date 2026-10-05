# Security Review Skill

## Purpose

Evaluate whether a change introduces or preserves security risk.

## Use when

The change involves secrets, auth, authorization, payments, personal data, inputs, outputs, dependencies, infrastructure, filesystem, or network boundaries.

## Do not use when

The change has no meaningful security surface; still apply the global security principles.

## Procedure

1. Map trust boundaries, identities, assets, data flows, and privileges.
2. Check authentication, authorization, validation, encoding, injection, secret handling, logging, dependency, and deployment concerns.
3. Consider abuse cases, replay, enumeration, privilege escalation, denial of service, and data leakage where relevant.
4. Verify safe defaults and failure behavior.
5. Confirm tests cover denied access, malformed input, and sensitive-data handling.
6. Escalate specialist review for high-impact or uncertain risk.

## Verification

Run repository security checks and focused tests. Inspect configuration and diff for secrets. Report what was and was not assessed.

## Expected output

Threat surface, findings by severity, mitigations, verification evidence, residual risk, and escalation needs.

