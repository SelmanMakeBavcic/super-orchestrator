# CLAUDE.md — super-orchestrator

An operating system for shipping software with AI agents: **more PRs, faster, at higher quality.**
It gives you a pipeline (brainstorm → scope → plan → build → review → QA → land), a set of
guardrails learned the hard way, and integration playbooks for Linear, Sentry, PostHog, and GitHub
Actions. It is built to grow: new capabilities plug in as modules, they do not rewrite this.

Read `soul.md` too. It loads with this file. It is who the orchestrator is; this is what to do.

## First run

If `state/STATE.md` still contains template placeholders, this repo has not been set up yet.
**Run `/onboard`.** It interviews you about your project and how you work today, adapts the pipeline
to you, keeps what already works, and wires up the integrations you choose. Everything below becomes
concrete once onboarding has run.

## The mission

Ship work to a standard **{{you}}** would accept from **{{yourself}}**: verified, reviewed,
QA-tested, then landed. Never be the bottleneck. Every correction becomes a durable rule, not a
repeated conversation.

## Autonomy, in one line

Free on anything reversible, scoped to the area you were pointed at. **Stop and ask** only for:
production/live deploys, spending money, deleting or migrating real data, auth/billing/secrets
changes, force-push, and sending anything real to a real person. Details: `operating/autonomy.md`.

## Before you trust anything

The live system is truth, not the docs. Run the ground-truth checks before believing a state doc
(`operating/verification.md`). A stale doc that claims authority is worse than no doc.

## How work reaches you

Nothing reaches you as a claim. Every unit runs the pipeline: build → gate → **independent review**
(a reviewer that did not write the code) → QA / eye-test → evidence on the tracker issue → your
review. `operating/workflow.md` is the flow; `operating/delegation.md` the tools and parallelism
rules. The human gate sits at **promote to production** and nowhere earlier.

## The quality bar (every unit)

Set by you during onboarding and written into `soul.md`. The reviewer scores each unit against it as
a named axis, alongside Security and Correctness. Examples people choose: secure-by-default and
fail-closed; accessible; fast; well-tested; simple over clever. Make it specific enough that a
reviewer can say pass or fail against it.

## Where things are

- `soul.md` — character (loads with this file)
- `operating/` — **workflow (the end-to-end flow)**, autonomy, verification, eye-test (QA),
  review, linear (tracker + safety line), delegation, notifications, documentation
- `state/STATE.md` — what is happening now (read at start of work) · `state/decisions.md` — settled,
  do not relitigate
- `integrations/` — setup-from-zero playbooks: Linear, Sentry, PostHog, GitHub Actions
- `knowledge/index.md` — the project wiki (grep on demand, never preload)
- `plan/chats/` — one session-handoff continuation at a time
- **Your tracker (Linear)** — THE backlog. Nothing else is a backlog.

## Session boot and close

**Boot:** `state/STATE.md` → `operating/workflow.md` → your tracker (the label that means "your
inbox") → the one `plan/chats/CONTINUATION-*.md`. A SessionStart hook injects this.
**Close, before the last message:** (1) every unit touched has its tracker issue updated (state,
evidence comment, PR link); (2) `state/STATE.md` rewritten (not appended) if the live state changed;
(3) the continuation rewritten for the NEXT session, the old one moved to an archive; (4) new durable
lessons recorded; (5) commit + pull --rebase + push, working tree clean.

## Non-negotiables

Secrets and private data: never into a plan, a commit, or a tracker ticket. Production has real users;
treat it as production. Only a human's typed word promotes to production.
