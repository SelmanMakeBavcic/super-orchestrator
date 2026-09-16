# operating/delegation.md — subagents, parallel work, and swarm safety

_When to use a workflow, a subagent, or an unattended shift. And the pipeline every unit runs before
it reaches you._

## The delivery pipeline

Nothing reaches you as a claim. Every unit runs all of these, in order. Stages 2–4 are the "check
every time" and happen before you see anything:

```
1 BUILD      the unit, in its own worktree, scoped to a named area
2 SELF-GATE  the mechanical gate for that repo (operating/verification.md), green
3 REVIEW     an independent read-only reviewer who did not write the code
4 EYE TEST   if anything visual: browser, both themes/languages, desktop + 375px, screenshots
5 EVIDENCE   bundle: the diff, gate output, review verdict, screenshots, cost, what changed and why
6 YOU        read the bundle, approve, the orchestrator lands it
```

- A red at any stage loops back to stage 1 **with the failure preserved** and either the fix or the
  different approach stated. Never "X failed, retrying" with no detail.
- The pipeline is per unit. Ten parallel units are ten independent pipelines.
- Only you land to `main`. An unattended agent never reaches stage 6's landing.
- **Stage 3 REVIEW gates EVERY merge, `dev` AND `main`.** Run the review on the branch diff and merge
  only if nothing is blocking. **Tests-green is not sufficient to merge, even to `dev`.**

## Which tool for which shape

| Shape of work | Tool | Why |
|---|---|---|
| One coherent unit | a subagent (capable model, high effort) | clean context, returns a distilled result |
| Fan-out: audit, migration, sweep, many-file change | a dynamic **workflow** | it awaits its own agents and returns their results |
| Recurring unattended work | a **shift** | boots from state, claims one task, works to completion, reports, exits |
| A decision with real stakes | a council (independent attempts → peer review → pick) | for the hard forks |

Default subagents to a capable model at high effort. Drop to cheaper tiers only for mechanical work
(mass rename, log scraping).

## Swarm rules (fan-out safety)

Fan-out happens **inside stage 1 only**. When more than one worker runs at once:
- Each worker in its **own git worktree**, never the shared checkout. Parallel writes to one checkout
  are the classic multi-agent corruption.
- Each worker gets an explicit **"files you must not touch"** list (the shared merge-conflict
  magnets). If a worker needs one, it **stops and reports**; the change is applied once, at merge, by
  the Lander.
- Each worker gets its **own scratch resources** (its own scratch DB filename, its own branch).
- Cap concurrency. More parallel workers than the machine can gate just means slower, flakier gates.

## Briefs

A worker gets a brief in the Agent Brief shape (see `operating/workflow.md` §6):
- `GATED: yes|no` as the literal first line (machine-checked; gated units cannot auto-land)
- **Why** (the observed problem, dated), **Scope** (numbered, each independently checkable),
  **Discipline** (TDD where it fits, the gate, the no-touch list, a `FOLLOWUPS:` block), **Verify**
  (what to run/look at, at which viewport, against which reference)
- Anchor to an **exact file or URL**, never "the design" or "the docs". Name the reference.
- Common context is factored into one shared file the briefs link to, so it cannot drift.

## Reviewer independence

Stage 3 is never the author. Every serious defect is caught by a read-only reviewer and never by the
writer. The reviewer looks for the things in `operating/verification.md` and `operating/review.md` —
named-behaviour tests at route level, absence-assertion traps, every writer of a value, the served
artifact.
