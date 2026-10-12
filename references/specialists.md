# Specialist procedures

Source material, not output. These are the procedures v1 shipped as seven separate `specialist-skills/`. In v2 they are **not** copied into the generated install by default, because the role docs and workflow templates already carry the procedure, and a generic copy fails the necessity test (`references/selection.md`).

Use them two ways:

1. **When filling a role body or workflow template**, draw the specific steps the repo warrants. A `fix.md` for a repo with a known-good commit history should say `git bisect`; one for a repo with three commits should not.
2. **When writing an optional `.agent/skills/<name>.md`**, under the conditions in `references/selection.md`. Bind it to the repo's own tools and delete every step the repo gives nothing to say about.

Each block below ends with where its content normally lands in a v2 install.

## Debugging

Define expected vs observed, and when it started. Build the smallest reliable reproduction; for intermittent failures find what raises the failure rate (load, ordering, timing, data). Gather error text, stack traces, logs, recent changes (`git log`, `git bisect` when there is a known good state). Narrow by halving the search space each step — by commit, by input, by layer — tracing the real execution path rather than code you assume is involved. State one hypothesis and the observation that would disprove it; change one thing at a time. The cause is confirmed when you can explain every symptom and turn the failure on and off. Then look sideways for the same mistake in sibling code, and remove all instrumentation.

→ `workflows/fix.md` step 1, and the investigator role body.

## Testing

Read two or three good existing tests first: framework, locations, naming, fixtures, and what kind of test covers what kind of code. List behaviors from the requirement, not the implementation: normal cases, boundaries, invalid input, error paths, permissions. Choose the lowest level that exercises the behavior for real. One behavior per test, with a name that states it; assert on outcomes, not internal calls. Fake what is slow or external; never mock the code under test. Prove the test can fail — run it against the pre-change code and check it fails for the right reason. Keep it deterministic: no reliance on real time, test order, shared state, or the network. For flaky tests, reproduce by repetition and fix the cause; never add retries or sleeps to hide it.

→ the tester role body and `rules/testing.md`.

## Database

Learn the engine, migration tool, naming, and how schema changes reach each environment relative to code deploys. Establish what reads and writes the affected tables, and approximate data volume. If old code runs against the new schema at any moment, use expand → migrate → contract. Assess locks, table rewrites, index build time, and replication; on large tables use the engine's online options and batch data changes. Express invariants as constraints where the project does; make data changes idempotent and bounded. Include the rollback or state plainly that it is irreversible. Never edit a migration already applied elsewhere. Refresh generated artifacts the project keeps in sync (schema dumps, generated types).

→ `workflows/migration.md`, and the schema checkpoint in `rules/checkpoints.md`.

## API design

Read three comparable operations before designing: naming, resource structure, request/response shapes, error format, status codes, pagination, auth, versioning, and where the contract is defined. Identify the consumers and whether they can all be changed and deployed together — if not, compatibility rules apply. Design from the consumer's side, in the project's existing vocabulary. Stay consistent with existing conventions even where you would choose differently; a second convention costs more than an imperfect first one. Define every failure mode in the project's error shape. Adding optional things is usually safe; removing, renaming, retyping, tightening validation, or changing defaults breaks consumers. Cover authorization per operation, idempotency for retried writes, and limits on list sizes and payloads. Update the contract artifacts the project keeps.

→ the only specialist with no default home. This is the realistic candidate for `.agent/skills/api-design.md` on a repo whose API other teams consume.

## Refactoring

State what becomes easier and how you will know it worked. Find every use, including strings, configuration, reflection, generated code, and consumers outside the repo. Confirm tests cover current behavior; if not, write characterization tests that pin what the code does now, quirks included. Plan steps that each leave the code compiling and passing. Apply one kind of transformation at a time — rename, move, extract, inline, change signature — using automated refactoring where available. Run tests after every step; a failure means the last step changed behavior, so revert and take a smaller step. Migrate callers fully, then delete the old path: no two implementations, no shim without an agreed end date. Stop at the goal and record further improvements as follow-ups.

→ `workflows/refactor.md`.

## Security review

Establish what the change does and what data and privileges it touches. Map trust boundaries: where untrusted input enters and where it ends up — queries, commands, file paths, templates, outbound requests, logs, deserializers. Check that every new or changed operation authenticates, then authorizes for the specific resource, server-side; look for missing ownership checks and privilege escalation. Trace each input to each sink: validation at the boundary, parameterized queries, safe path handling, output encoding, size and rate limits. Check nothing sensitive reaches code, logs, errors, URLs, or client-visible responses. Check token handling, expiry, CSRF protections, and check-then-act races. Check new packages, changed permissions, opened network paths, and disabled protections. Discard any finding you cannot describe a concrete exploit path for. Confirm each finding against the code path, not a pattern match.

→ the reviewer role body and `rules/security.md`.

## Commit

A unit is one thing a reader can review and revert on its own; if its purpose needs more than one sentence, split it. Branch before the first edit. Commit each unit as soon as it is coherent and green, rather than saving commits for the end. Stage by path — never `git add -A`, `git add .`, or `git commit -a`. Never commit secrets, local env files, build output, scratch documents, or another author's files. No `Co-Authored-By`, `Generated with`, `Signed-off-by`, or `Assisted-by` trailers, and nothing in files or PR descriptions naming who or what wrote the work. Do not push, tag, open a PR, or merge unless asked. Never rewrite published history, force-push, or bypass hooks without explicit instruction.

→ `rules/checkpoints.md` and `PROJECT.md` › Branches and release. The skill itself follows this while installing.
