# Step 3: Ask When Uncertain

Ask clarifying questions when analysis shows ambiguity. Present options and collect user preferences to customize generated files.

## Question Protocol

For each ambiguity from analyze.md:

1. **State the ambiguity** — what did we find that's unclear?
2. **Offer 2-4 candidate answers** — include most likely first
3. **Provide brief rationale** — why each option matters
4. **Record user choice** — feed into generate.md

Format:

```
🤔 [Question Title]

[One sentence describing the ambiguity]

A) [Candidate 1] — [Why this matters]
B) [Candidate 2] — [Why this matters]
C) [Candidate 3] — [Why this matters]
D) Tell me something different
```

---

## Question Library

### Testing & Quality

**Q1: Testing Framework (if multiple found)**

```
🤔 Primary Testing Framework

I found both Jest and Vitest configured. Which should agents treat as canonical?

A) Jest (jest.config.js is main; vitest is secondary)
   → Agents will recommend Jest for new tests
B) Vitest (faster feedback, modern tooling)
   → Agents will recommend Vitest for new tests
C) Both equally (tests should pass in both)
   → Agents will ensure compatibility
D) [Your preference]
```

**Q2: Code Review Requirements**

```
🤔 Code Review Rigor

How much code review should agents expect for different task levels?

A) Always required (all changes need review)
   → L0-L4: all changes require approval
B) Only for critical paths (payments, auth, core algorithms)
   → L0-L1: no review; L2+: review required
C) Self-review only (trust but verify)
   → L0-L1: self-review; L2+: peer review
D) [Tell me your process]
```

**Q3: Test Coverage Expectations**

```
🤔 Test Coverage Target

What's the expected test coverage for new code?

A) Comprehensive (unit + integration + E2E)
   → All features need tests
B) Pragmatic (unit + integration for new code)
   → 70%+ coverage target
C) Minimal (unit tests for logic only)
   → Test what breaks most
D) [Your target percentage]
```

---

### Architecture & Planning

**Q4: Planning Ceremony**

```
🤔 When Should Agents Plan?

For what task levels should agents create a plan before implementing?

A) L2+ (larger changes, cross-boundary work, risky refactors)
   → Small tasks move straight to implementation
B) L1+ (almost everything except tiny fixes)
   → Thorough upfront planning
C) Always (even typos get a plan)
   → Maximum ceremony
D) [Your preference]
```

**Q5: Monorepo Strategy (if monorepo detected)**

```
🤔 Monorepo Boundaries

Should agents treat workspace boundaries as hard constraints?

A) Hard boundaries (never move files across packages)
   → Cross-package changes require architectural review
B) Soft boundaries (discourage but allow if necessary)
   → Allow cross-package refactors with caution
C) No boundaries (same as single project)
   → Workspaces are just organization
D) [Your strategy]
```

**Q6: Architecture Constraints (if multiple patterns found)**

```
🤔 Architecture Pattern

I found both [Old Pattern] and [New Pattern] in the code.
Which should new code follow?

A) [New Pattern] (migrate toward this)
   → New code follows modern pattern; old code migrates gradually
B) [Old Pattern] (stable, established)
   → Stick with what works; don't migrate
C) Gradual migration (context-dependent)
   → Use new pattern for new code; refactor old code opportunistically
D) [Mixed approach]
```

---

### Git & Deployment

**Q7: Commit Message Convention**

```
🤔 Commit Message Format

What should commit messages follow?

A) Conventional Commits (feat: add login, fix: password reset)
   → Agents will follow feat/fix/docs/refactor/test/chore pattern
B) Free-form (descriptive but flexible)
   → Agents will write clear messages without strict format
C) Something specific to your team
   → [Describe your format]
```

**Q8: Deployment & Verification**

```
🤔 Verification Before Merging

What verification should agents report before changes are ready?

A) Full suite (unit + integration + E2E + lint + build)
   → Report all checks passing
B) Core checks (unit + lint + build)
   → E2E can run in preview
C) Minimal (unit tests + lint)
   → Rely on CI to catch issues
D) [Your verification checklist]
```

---

### Security & Compliance

**Q9: PII & Data Handling (if detected)**

```
🤔 PII Handling Requirements

What rules should agents follow for data with PII?

A) Strict (never log, encrypt at rest, minimal retention)
   → Extra caution in all changes touching user data
B) Standard (follow company policy)
   → [Link to policy or describe]
C) Minimal (no special treatment beyond normal security)
   → No extra caution needed
```

**Q10: Secrets & Environment Variables**

```
🤔 Secrets Management

How should agents handle environment variables and secrets?

A) Vault/KMS (centralized secret management)
   → Reference documented vault locations
B) .env files (never commit secrets)
   → Follow .env.example pattern
C) Environment variables (set by deployment platform)
   → Reference platform docs (Vercel, AWS, etc.)
D) [Your approach]
```

**Q11: Authentication Strategy (if detected)**

```
🤔 Authentication & Authorization

Which authentication approach should agents understand?

A) Built-in JWT (manage tokens locally)
   → Explain JWT handling, token refresh, revocation
B) External service (Clerk, Auth0, NextAuth)
   → [Name the service]; explain integration points
C) Session-based (server-managed sessions)
   → Explain session storage and validation
D) [Multiple approaches]
```

---

### Design System & UI (if UI project)

**Q12: Design Tokens Format**

```
🤔 Design Tokens Storage

How are design tokens defined and consumed?

A) CSS custom properties (--color-primary, --spacing-4)
   → Reference root CSS variables
B) Tailwind config (tailwind.config.ts)
   → Reference theme configuration
C) Theme object (theme.ts or theme.json)
   → Reference TypeScript or JSON object
D) [Other system]
```

**Q13: Component Library Approach**

```
🤔 Component Architecture

Which component library or pattern should agents follow?

A) Custom components (src/components/ with internal patterns)
   → Reference your patterns
B) shadcn/ui (Radix + Tailwind)
   → Reference shadcn docs for new components
C) Headless UI / Radix (unstyled primitives)
   → Reference framework, apply custom styles
D) [Your library]
```

**Q14: Theming Strategy**

```
🤔 Light/Dark Mode & Theming

How should agents implement theming?

A) Light/Dark (two themes, CSS vars or class-based)
   → Explain how to toggle and style for both
B) Multiple themes (3+ color schemes)
   → List available themes and how to implement
C) No theming (single color scheme)
   → Standard light mode only
D) [Custom approach]
```

**Q15: Accessibility Requirements**

```
🤔 Accessibility Standards

What a11y standards should agents follow?

A) WCAG 2.1 AA (strict, comprehensive)
   → Test with screen readers, keyboard nav, color contrast
B) WCAG 2.1 A (baseline)
   → Core accessibility needs
C) Not a priority (build first, a11y later)
   → No special a11y considerations
D) [Your standard]
```

---

### Team & Process

**Q16: Code Review Authority**

```
🤔 Who Can Approve Changes?

Who should review and approve agent-generated changes?

A) Anyone with write access (peer review culture)
   → Any team member can approve
B) Designated reviewers (specific people per area)
   → [List code owners or paths]
C) Tech lead / PM approval
   → Specific person approves all changes
D) [Your process]
```

**Q17: Refactoring Risk Tolerance**

```
🤔 Refactoring & Code Cleanup

How aggressive should agents be with refactoring?

A) Aggressive (refactor opportunistically, improve as we go)
   → Clean up old patterns; modernize alongside features
B) Conservative (only refactor what's necessary for the task)
   → Touch only what's required; avoid scope creep
C) Minimal (only if it directly fixes a bug)
   → No proactive cleanup
D) [Your preference]
```

---

### Language/Framework Specific

**Q18: TypeScript Strictness (if TypeScript project)**

```
🤔 TypeScript Configuration

What should agents know about TypeScript strictness?

A) Strict mode (strict: true, all types required)
   → No `any`; all types explicit
B) Pragmatic (strict: true with some exceptions)
   → [Describe your exceptions]
C) Loose (strict: false, optional typing)
   → `any` is acceptable for complex types
D) [Your tsconfig strategy]
```

**Q19: Testing Framework Approach (language-specific)**

```
🤔 Testing Patterns

What testing patterns should agents follow for [Language]?

A) Table-driven tests (Go style)
   → Tests as data-driven tables
B) Describe/it blocks (Jest/RSpec style)
   → Nested describe blocks with it() cases
C) Parameterized tests (pytest or JUnit style)
   → @pytest.mark.parametrize or @ParameterizedTest
D) [Your convention]
```

**Q20: Error Handling Strategy**

```
🤔 Error Handling

How should agents handle errors in this codebase?

A) Exceptions (throw/try-catch paradigm)
   → Use exceptions for errors; catch at boundaries
B) Result types (Ok/Err or Result<T,E> pattern)
   → Return Result types; handle explicitly
C) Error codes (return error codes)
   → Status codes or error codes in responses
D) [Mixed approach]
```

---

## Conditional Questions

Ask these only if specific signals are present:

### If Performance is Critical

```
🤔 Performance Optimization

What are the performance constraints for this project?

A) Edge-first (deployed to edge compute)
   → Bundle size critical; server responses <100ms
B) Real-time (WebSocket, sub-100ms responses)
   → Latency is feature; optimize responsiveness
C) Scale-heavy (millions of requests)
   → Database efficiency critical; optimize queries
D) Standard (normal performance expectations)
   → No special optimizations needed
```

### If Real-time Features Present

```
🤔 Real-time Architecture

How should agents understand real-time updates?

A) WebSocket (persistent connections)
   → Explain broadcasting, fallbacks, reconnection
B) Server-sent events (streaming HTTP)
   → Explain event format and subscriptions
C) Polling (client-initiated checks)
   → Explain polling interval and backoff
D) [Your approach]
```

### If Payments Detected

```
🤔 Payment Processing

What should agents know about payments?

A) Stripe (primary payment processor)
   → Explain webhook handling, idempotency, test mode
B) [Other processor]
   → [Explain their integration]
C) Internal system ([Describe])
   → [Custom implementation details]
```

---

## Recording Answers

Create a file: `.ai/questions-answered.md`

```markdown
# Adoption Decisions

Generated: 2026-10-05

## Testing & Quality

**Primary Framework**: Jest (Q1: Candidate A)  
**Code Review**: Required for L2+ (Q2: Candidate B)  
**Test Coverage**: Pragmatic 70%+ (Q3: Candidate B)

## Architecture

**Planning Ceremony**: L2+ tasks need planning (Q4: Candidate A)  
**Monorepo Boundaries**: Hard constraints (Q5: Candidate A)  

## Git & Deployment

**Commits**: Conventional Commits (Q7: Candidate A)  
**Verification**: Core checks + lint + build (Q8: Candidate B)

## Special Decisions

- Refactoring: Conservative approach (only what's needed)
- TypeScript: Strict mode with documented exceptions in tsconfig.json
- Performance: Standard expectations (not edge-compute)

---

## Notes for Future Runs

These answers are locked in. To change them, re-run with `--update-decisions`.
```

## When to Stop Asking

Move to generate.md once:
- All ambiguities have been addressed
- User has chosen an option for each question OR accepted the recommended default
- Answers are recorded in `.ai/questions-answered.md`
