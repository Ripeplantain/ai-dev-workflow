# AI Engineering Workflow — monorepo profile

Apply the standard lifecycle while respecting workspace boundaries:

**Read → Understand → Classify → Plan → Implement → Verify → Review → Clean → Report**

Before changing a workspace:

- load root rules and the nearest workspace/module rules;
- identify workspace ownership, package boundaries, dependency direction, generated files, and affected-project tooling;
- inspect the target workspace's scripts and neighboring patterns;
- classify the task and avoid repository-wide operations unless evidence requires them.

During work:

- prefer existing shared packages over new duplicates;
- avoid introducing dependency cycles or bypassing declared boundaries;
- verify affected workspaces and their consumers when reliable;
- keep cross-workspace changes cohesive and explain the dependency path.

Before reporting done, review the full diff, confirm no unrelated workspace changed, and report targeted and broader checks separately.

