# [PROJECT_NAME] Agent Roles

**Agents are optional.** This document describes roles available for larger work. Smaller tasks can be handled sequentially in one agent. Do not require subagents; load a specialist skill instead.

---

## Planner

**When to use**: L2+ features, cross-boundary changes, risky refactors, migrations

**Do not use**: L0-L1 (too much overhead)

**Lifecycle**:
1. Discover the repository (see `references/repository-discovery.md`)
2. Understand the current state
3. Create a < 500-word plan document
4. Get approval

**Responsibilities**:

- Analyze impact on [PRIMARY_LANGUAGE]/[FRAMEWORK] code
- Check for cascading changes
- Identify files that will change
[CONDITIONAL:is-monorepo]
- Check workspace boundaries (see `rules/architecture.md`)
- Identify affected packages
- Plan shared code updates
[CONDITIONAL:has-database]
- Plan database schema changes (see `rules/database.md`)
- Identify migration files
[CONDITIONAL:has-tests]
- Plan test coverage (unit, integration, E2E)
- Identify test files to add/update
[CONDITIONAL:has-auth-or-payments]
- Flag security considerations
- Plan for audit/compliance if needed
[CONDITIONAL:is-ui]
- Plan design system impacts
- Check for token/component changes (see `rules/design-system.md`)

**What a good plan includes**:
- Goal (one sentence)
- Affected files (list)
- Architecture changes (if any)
- Database changes (if any)
- Test strategy (unit, integration, E2E)
- Risks (what could go wrong?)
- Verification plan (how we'll know it works)

**Approval**: [CODE_REVIEW_AUTHORITY]

**Handoff to Implementer**:
```
PLAN:
[Plan document]

Next:
1. Implement changes
2. Run: `[MAIN_TEST_COMMAND]`
3. Verify: [VERIFICATION_STEPS]
4. Submit for review
```

---

## Implementer

**When to use**: After planning is approved, implement the change

**Do not use**: For planning, review, or verification

[CONDITIONAL:has-implementer-role]
**Lifecycle**:
1. Receive plan from Planner
2. Understand current state
3. Make the smallest correct change
4. Run verification
5. Hand off to Reviewer

**Responsibilities**:

- Follow [PRIMARY_LANGUAGE] conventions (see `rules/engineering.md`)
- Reuse existing abstractions (never create duplicates)
- Add tests as specified in plan
- Keep commits clean (follow `rules/git.md`)
[CONDITIONAL:is-monorepo]
- Respect workspace boundaries
- Update shared code carefully
[CONDITIONAL:has-design-system]
- Use design tokens (never hardcode values)
- Follow component patterns
[CONDITIONAL:has-security-concerns]
- Review `rules/security.md`
- Never log secrets
- Validate inputs appropriately

**Success criteria**:
- Code matches style (passes linter)
- Tests pass locally
- No type errors (if TypeScript)
- Commits are clear (Conventional Commits)

**Handoff to Reviewer**:
```
IMPLEMENTATION:
Commits: [git commit hashes]
Tests: Passing locally
Verification: [verification results]

Next: Code review via Reviewer role
```

---

## Investigator

**When to use**: Bug reports, performance issues, mysterious failures, "how does this work?"

**Do not use**: For planning or implementation (except as discovery)

**Lifecycle**:
1. Discover repository
2. Understand the bug/issue
3. Run investigation commands
4. Create minimal reproduction
5. Report findings

**Responsibilities**:

- Run discovery commands (see `references/repository-discovery.md`)
- Understand the codebase structure
[CONDITIONAL:has-tests]
- Review [PRIMARY_TEST_FRAMEWORK] tests related to issue
- Look for edge cases in test coverage
- Run tests with different parameters
[CONDITIONAL:has-database]
- Inspect database schema (if applicable)
- Run queries to understand data state
[CONDITIONAL:has-logs-or-metrics]
- Check logs for error patterns
- Review metrics for performance issues
- Check deployment platform dashboard ([DEPLOYMENT_PLATFORM])
[CONDITIONAL:is-ui]
- Test in different browsers/devices
- Check browser console for errors
- Use development tools to inspect state
[CONDITIONAL:language-specific]
[LANGUAGE:typescript]
- Check TypeScript errors and type narrowing
- Use debugger breakpoints
[LANGUAGE:go]
- Use pprof for profiling
- Check goroutine leaks with goroutineprofile
[LANGUAGE:python]
- Use pdb for debugging
- Profile with cProfile
- Check pytest verbose output

**Investigation template**:
```
ISSUE: [Bug title]

Reproduction:
- Steps to reproduce
- Expected behavior
- Actual behavior

Investigation:
- Command: [What I ran]
- Result: [What I found]

Findings:
- Root cause: [What's actually happening]
- Affected code: [File locations]

Next steps:
- [Recommendation for Implementer/Planner]
```

**Handoff to Planner/Implementer**:
```
INVESTIGATION COMPLETE:

[Investigation template above]

Assign to: Planner (for design) or Implementer (if straightforward fix)
```

---

## Reviewer

**When to use**: All [CODE_REVIEW_REQUIREMENT] code changes

**Do not use**: For implementation (except to understand code)

**Lifecycle**:
1. Receive implementation
2. Read the plan (context)
3. Review code against standards
4. Run verification
5. Approve or request changes

**Responsibilities**:

- Check against `rules/engineering.md` for style
- Verify tests added and passing
- Check for type safety issues
[CONDITIONAL:is-monorepo]
- Verify monorepo boundaries respected (see `rules/architecture.md`)
- Check for circular dependencies
[CONDITIONAL:has-design-system]
- Verify design system used correctly
- Check for hardcoded values (should use tokens)
[CONDITIONAL:has-security-concerns]
- Review for security issues (see `rules/security.md`)
- Check for secrets in code/logs
- Verify auth/payment flows
[CONDITIONAL:has-performance-concerns]
- Check for N+1 queries (if database)
- Review for unnecessary renders (if UI)
- Verify caching strategy
- Profile critical paths

**Review checklist**:
- [ ] Code style matches linter output
- [ ] Tests are comprehensive
- [ ] No type errors (`npm run type-check` or equivalent)
- [ ] Tests pass locally: `[MAIN_TEST_COMMAND]`
- [ ] Build succeeds: `[BUILD_COMMAND]`
- [ ] Commits follow Conventional Commits
- [ ] No secrets or hardcoded values
- [ ] Documentation updated (if user-facing)
- [ ] Follows architecture patterns (see `rules/architecture.md`)

[CONDITIONAL:is-ui]
- [ ] Design tokens used (no hardcoded colors/sizes)
- [ ] Works in light and dark modes
- [ ] Accessible (ARIA labels, keyboard navigation)

[CONDITIONAL:has-database]
- [ ] Database migrations included
- [ ] Migrations are reversible
- [ ] No breaking changes to API

**Approval decision**:

**Approve if**:
- All checks pass
- Tests are comprehensive
- Code follows conventions
- No security issues

**Request changes if**:
- Code doesn't match style
- Tests are incomplete
- Type errors present
- Security concerns detected
- Architecture violated

**Handoff**:
```
REVIEW COMPLETE

Approved ✅ / Changes requested ❌

[Comments on specific issues]

Next: Merge to [TARGET_BRANCH] (if approved)
```

---

## Summary

**Typical workflow for L2+ change**:

```
User describes task
  ↓
Planner creates plan
  ↓
Implementer implements (given plan)
  ↓
Reviewer reviews (given plan + code)
  ↓
Approve: Merge
  ↓
Investigate later (if issues): Investigator debugs
```

**Typical workflow for L0-L1 change**:

```
User describes task
  ↓
Single agent: discover → understand → implement → review → commit
```

**If the project doesn't support subagents**: Execute all roles sequentially in one agent context.

---

## Contacts & Authorities

[CONDITIONAL:has-code-review-authority]
**Code review authority**: [CODE_REVIEW_AUTHORITY]
**Can approve changes**: [WHO_CAN_APPROVE]

[CONDITIONAL:has-security-authority]
**Security review**: [SECURITY_AUTHORITY]

[CONDITIONAL:has-architecture-authority]
**Architecture review**: [ARCHITECTURE_AUTHORITY]

For questions about roles, see the individual agent instructions above or ask your team.
