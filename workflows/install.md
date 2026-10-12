# Install mode

Goal: from repo evidence, produce a plan the user approves in one glance, then write the smallest install that changes how agents behave here.

## 1. Gather evidence

1. Run `scripts/scan_repo.sh <root>`. If `git_dirty_count` > 0, stop and run the re-orient report first (`workflows/reorient.md`). Ask how to handle the dirty files before installing.
2. Read, in this order and only as far as needed:
   - Existing `AGENTS.md`, `CLAUDE.md`, nested `*/AGENTS.md`, `.cursor/rules`, `.github/copilot-instructions.md`. These carry the user's own rules; anything you generate must agree with them.
   - Root `README`, `docs/` index, ADRs, spec/prompt docs (`PROMPT.md`, `prompts/`). The user writes specs before code; the spec is the best description of intent.
   - Manifest files: `package.json` (scripts, packageManager, workspaces), `pyproject.toml`, `requirements*.txt`, `Makefile`, `docker-compose*`, CI files.
   - Only then, code. Sample the entry points the scan lists. Do not read the whole tree.
3. Read `references/invariants.md` and look for project rules worth enforcing.
4. If the scan shows `ai_signals` or `data_signals`, read `references/data-ai.md`. If it shows workspaces or several deployables, read `references/monorepos.md`.

How to read, when the scan leaves a question open:

- Go from cheap and broad to expensive and narrow. Stop exploring a dimension once you can state its facts with confidence; discovery is not an audit of the codebase.
- Record each fact with the file it came from. `PROJECT.md` cites sources, so collect them as you go.
- Prefer what is executed over what is described: CI config and manifest scripts outrank a README that may be stale.
- When sources disagree, check which is current (`git log` on the files) and note the disagreement. If that does not settle it and the answer changes what you write, it becomes a question for step 4.
- Mark anything you could not confirm as unknown. Do not fill a gap with what is typical for the stack.
- Trace one representative request, command, or data flow end to end. It reveals more about the real architecture than any directory listing.
- Do not read vendored code, build output, lockfile bodies, or generated files. Do not open secret files; note that they exist.

## 2. Classify

Decide two things and say them in the plan, each with one line of evidence:

- **Size**: `small`, `medium`, or `large`.
- **Shape**: every label that applies — `web-app`, `api`, `monorepo`, `multi-service`, `library`, `cli`, `llm-feature`, `data-pipeline`, and the rest.

Signal tables for both are in `references/selection.md`. Size controls how much you write; shape controls which roles and rules appear.

## 3. Decide the artifacts

Read `references/selection.md`. Start from the selection table for this size and shape, then put every candidate through the necessity test and write down keep or skip with a one-line reason. That list becomes the plan and part of the final report.

Settle the roster here too: 4–6 roles from `references/roles.md`.

## 4. Ask only what evidence cannot answer

Batch into one message, at most four questions, following `references/questions.md`. Typical gaps: which test command is authoritative when there are several; branch naming per kind of work, unless a doc, hook, or CI filter states it; whether this is a team repo; deploy target if none is visible; the paid-call threshold for LLM repos. Never ask what the scan already answered.

Skip this step when the user said `--yes` or equivalent, and record the resulting assumptions in the report.

## 5. Show the plan

Use exactly this shape, one screen, no prose around it beyond a lead sentence:

```
agent-workflow v2.0.0 install plan: <repo-name>
Classified: <size> · <shape(s)>
Evidence: <stack in one line> · tests: <cmd or "unknown"> · CI: <system or none>

Roles (<n>): planner [strong] · implementer [default] · tester [default] · reviewer [strong] · <...>
Adapters: Claude Code (.claude/agents) · Codex (.codex/agents)   ← only the tools in use

Will write:
  AGENTS.md                      <create | merge into existing (N lines kept)>
  CLAUDE.md                      @AGENTS.md pointer
  .agent/PROJECT.md              stack, commands, layout, version stamp
  .agent/rules/checkpoints.md    hard stops
  .agent/rules/repo-sanity.md    what not to add
  .agent/rules/<x>.md            <one line why, per rule>
  .agent/agents/<role>.md        × n
  .agent/workflows/<x>.md        <one line why, per workflow>
  .claude/agents/<role>.md       × n
  .codex/agents/<role>.toml      × n
  <data/AI artifacts if any>
Total: <N> files

Skipped: <artifact — one-line reason>, <...>
Enforced invariants: <list or "none found">
Found, not touching: <dirty files / lockfile drift / wrong-case names / stale config, or "nothing">

Approve? (yes / edit / no)
```

Which tools get adapters: Claude Code if `.claude/` or `CLAUDE.md` exists or the user uses it; Codex if `.codex/` exists or the user uses it. When nothing indicates either, generate both. Both are cheap and the user switches between them.

On approval, do the work. A plan the user approved and then got back as "I recommend creating a `.agent/` directory" is a failed run.

## 6. Write

Order matters so a half-finished install is still coherent:

1. `.agent/PROJECT.md` (from `templates/PROJECT.md`). Fill the `version:` stamp with the skill version and today's date.
2. `.agent/rules/checkpoints.md`, then `repo-sanity.md`, then the other rules kept in step 3 (`templates/rules/`).
3. `.agent/agents/<role>.md` for each role (`templates/agents/`).
4. `.agent/workflows/*.md` (`templates/workflows.md`). Default set: `feature.md` and `fix.md`. Add others only per the conditions in `references/selection.md`.
5. Root `AGENTS.md`: create or merge. When merging, keep every existing line; add a short "Agent workflow" section that points into `.agent/`. If an existing section conflicts with a checkpoint, keep the stricter one and mention it in the report.
6. `CLAUDE.md` as `@AGENTS.md`.
7. Adapters, per `references/adapters.md`.
8. Monorepos: nested `apps/<x>/AGENTS.md` only where an app has commands or rules that differ from the root. These take precedence locally.

While filling each template: replace every `{{PLACEHOLDER}}` with a fact from the repo or an answer from step 4, follow each `INSTALLER:` note and then delete it, and delete any section the repo gives nothing to say about. An empty or generic section is worse than a missing one. Replace generic guidance with the local version wherever one exists — "follow existing patterns" becomes "new endpoints follow `src/routes/orders.ts`". Link to existing documentation instead of summarising it, and adjust cross-references so they point only at files you are actually writing.

## 7. Validate and report

1. Run `scripts/validate.sh <root>`. Fix every error.
2. Run the verification commands you recorded in `PROJECT.md`, where they are safe, fast, local, and need no install — the point is to confirm the commands exist and are spelled right. If one fails for reasons that predate you, record that; do not fix project code.
3. Re-read `PROJECT.md` as an agent who has never seen this repo: could you make a safe change with it?
4. Review your own diff (`git status`, `git diff`). Only `.agent/`, the entry files, and adapters should have changed. Delete anything generic enough to apply unchanged to any repo. Confirm no secrets, internal hostnames, or personal data were copied in.
5. Report per SKILL.md "Finish". Suggest a commit split such as `chore(agents): add agent workflow` for the generated files, kept separate from any pre-existing dirty work.

## New projects

For an empty or near-empty repo, evidence is thin. Use the user's spec or idea description as the evidence source, keep the install small (planner, implementer, tester, reviewer), and mark unknown commands as `TBD: set once scaffolded`. Never invent a command to fill the table — a plausible `pnpm test` that does not exist is the worst thing you can write, because agents run it confidently. The validator allows `TBD:` lines but flags them so the next update run fills them in.
