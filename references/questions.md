# The question step

One batch of questions, after evidence gathering and before writing anything. A wrong guess written into `.agent/` is repeated on every later task, which is why this step exists at all.

## What to ask

Ask when the answer changes what gets written **and** the repo cannot give it.

| Kind | Examples |
|---|---|
| Conflicting evidence | Two lockfiles from different package managers; a README command that CI or the manifest contradicts; two test runners with no sign which is canonical |
| A convention the repo does not establish | Branch naming (see below); commit message rules when the history shows no clear pattern |
| A fact nothing records | Deploy target, required environments, a command with no script, the paid-call threshold for an LLM repo |
| Intent | Things agents must always or never do here that no file states; whether a borderline artifact is wanted |

Never ask what the scan already answered. Never ask for something you could read in two files.

## How to ask

- Finish discovery first, then ask once. Do not interleave questions with exploration, and do not come back later for something you could have asked here.
- One to four questions. There is no fixed list beyond branch naming — every question comes from something this repo left open.
- For each, say what you found, then offer concrete options with your recommendation first, so the user can answer in a word.
- Use the agent's structured question tool if it has one; otherwise ask in one plain message and wait.
- An answer is evidence. Write it into `.agent/` as fact and name it in the report.

## Branch naming

Ask on every install unless the convention is **stated**: in a contributor document, an existing agent instruction file, a branch-name hook or lint rule, or CI branch filters that fix the pattern. In update mode, ask when `.agent/` records no convention or only an unconfirmed default.

Branch names seen in `git branch -a` or in merge commit subjects are not enough to settle it, because merged branches get deleted and the few survivors rarely show the whole rule. Use them as the recommended option instead, followed by `<type>/<short-slug>` when they disagree.

Ask for the pattern **per kind of work**, not for one pattern. Teams commonly name feature branches one way and bug-fix branches another, with further patterns for hotfixes, releases, or chores, and a different base branch for some of them. Ask which kinds of work have their own pattern, what each pattern is (prefix, separator, ticket ID, slug style), and which branch each is cut from.

Record the answer as one line per kind of work, in the user's own words for the kinds, so an agent starting a bug fix reads the bug-fix pattern and not a general one. It goes in `PROJECT.md` › Branches and release, and each generated workflow names the pattern for its own kind of work.

## When not to ask

Do not ask when the user said not to (`--yes`, "just do it"), or when nobody can answer — a non-interactive or scripted run. Then take the best-supported option and list each such choice in the report as an assumption, with the alternative you did not take.

`--yes` skips the plan approval wait and the question batch. It does not skip the report: every assumption still gets listed, and anything needing explicit approval (removing a file, renaming for case) still stops.

If discovery left nothing open, skip the step and say so in the report.
