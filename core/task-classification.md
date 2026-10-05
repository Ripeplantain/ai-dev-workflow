# Task Classification

Classification chooses the minimum safe process. It is a judgment based on change surface and failure cost, not a label inferred from the user's wording alone.

## Decision method

Consider:

1. **Scope** — one file, one module, multiple modules, or repository-wide?
2. **Contract** — internal detail, shared package, public API, schema, event, or user-visible behavior?
3. **Risk** — data loss, security, availability, compatibility, financial, or deployment impact?
4. **Uncertainty** — is the cause, architecture, ownership, or correct behavior unknown?
5. **Verification** — can the change be confidently checked with a focused command, or does it require broad/staged validation?

Choose the highest level indicated by any material risk factor. If evidence later reduces the scope, simplify the process and explain the change.

## Levels

### L0 — Trivial

Typo, formatting-only change, tiny documentation correction, or obvious one-line change with no behavior or contract impact.

**Flow:** Understand → Implement → Verify.

### L1 — Small

Localized bug, small UI change, minor validation or configuration adjustment with a bounded impact.

**Flow:** Discover → Understand → Implement → Verify → Report.

### L2 — Standard

Normal feature, endpoint, component, service behavior, or moderate bug affecting an established module.

**Flow:** Discover → Understand → Plan → Implement → Verify → Review → Report.

### L3 — Significant

Cross-module feature, database migration, authentication change, infrastructure change, shared package change, or work with meaningful compatibility/operational risk.

**Requires:** deeper discovery, dependency analysis, explicit plan, broader testing, security consideration, and independent review.

### L4 — Critical / Architectural

Architecture change, security-critical system, payment flow, authorization redesign, major migration, or breaking public API.

**Requires:** architectural reasoning, explicit risks and alternatives, staged implementation, comprehensive verification, rollback/rollout thinking, and a decision record when the choice has lasting consequences.

## Reclassification triggers

Pause and reclassify if discovery reveals a larger boundary, hidden data migration, security impact, incompatible consumer, unreliable verification, or an architecture decision not present in the original request.

