# Feature Development

Use for new behavior or an extension to an existing capability. Usually L2–L4.

## Flow

1. **Discover** — identify the entry points, architecture, contracts, data flow, and verification commands.
2. **Classify** — identify task level, risk, affected modules, and compatibility surface.
3. **Plan** — state behavior, files/modules, edge cases, tests, rollout, and out-of-scope work. Use a decision record for meaningful architectural choices.
4. **Implement** — follow existing patterns and keep the diff focused.
5. **Verify** — run affected checks, then broader checks proportional to risk.
6. **Review** — review as an independent engineer for correctness, security, duplication, and compatibility.
7. **Clean and report** — remove artifacts, inspect the diff, and report evidence plus follow-ups.

## Required plan questions

- What existing behavior must remain unchanged?
- Which boundary or contract changes?
- What happens on invalid input, failure, retry, and partial completion?
- What is the smallest useful test surface?

