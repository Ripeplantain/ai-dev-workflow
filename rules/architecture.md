# Rule: Architecture Preservation

Discover the architecture the repository has. Work within it.

## Discover

- Trace one or two representative requests, commands, or data flows end to end before changing structure.
- Identify the layers or modules, what each is responsible for, and which way dependencies point.
- Note where the code is inconsistent. Follow the dominant or most recent pattern, and check the Git history or docs to tell which one is current.

## Preserve

- Put new code where equivalent existing code lives.
- Respect the existing dependency direction. If the project goes Controller → Service → Repository → Database, a controller does not query the database.
- Reuse the existing mechanisms for configuration, errors, logging, validation, and data access.

## Do not impose

Do not introduce Clean Architecture, Hexagonal Architecture, DDD, the repository pattern, CQRS, microservices, a monorepo, or any other style because it is considered good practice elsewhere. A style the project does not use is a cost, not an improvement.

## When deviation is justified

Only when the task cannot be done correctly within the existing structure. Then:

1. State the specific limitation.
2. Propose the smallest deviation that removes it.
3. Treat it as at least L3 (see `references/task-complexity.md`) and get agreement before implementing.
4. Record the decision where the project records decisions.

## When writing project context

Describe the architecture as it is, in the project's own terms. Do not rename its layers to match a textbook pattern, and do not describe an aspiration as if it were the current state.
