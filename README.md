# super-orchestrator

An operating system for shipping software with AI agents — **more PRs, faster, at higher quality.**

It is a battle-tested workflow distilled from running agents in production, generalized so you can
drop it on top of your own project. It gives you:

- **A pipeline** — brainstorm → scope → plan → build → **independent review** → QA / eye-test → land.
  Nothing reaches your "done" pile as a claim; every unit carries evidence.
- **Guardrails** — each one learned from a real failure: never deploy to production without your word,
  a cry-wolf firewall on error signals, a loop-guard so agents stop instead of thrashing, and
  "verify the artifact, not the config."
- **Integration playbooks** — set up Linear (tracker), Sentry (error signal), PostHog (product/LLM
  analytics), and a GitHub Actions gate from zero.
- **A character** (`soul.md`) — truth over comfort, evidence over assertion, small and reversible
  over large and clever.

## Quickstart

1. **Clone this repo** into your project's workspace (or keep it beside your project).
2. Open it with Claude Code (or your agent of choice).
3. **Run `/onboard`.**

The onboarding interview asks about your project, your stack, and how you work today. It keeps what
already works for you, grafts the pipeline onto the gaps, wires up whichever integrations you want,
and hands you a ranked list of the first improvements to your PR flow. When it finishes, the repo is
configured for *you* — `soul.md`, `state/STATE.md`, and a setup checklist are filled in.

## What's inside

```
super-orchestrator/
  CLAUDE.md                 how the orchestrator operates (loads soul.md)
  soul.md                   the orchestrator's character (onboarding personalizes it)
  operating/                the workflow and its rules
    workflow.md             the end-to-end pipeline (start here after onboarding)
    autonomy.md             what proceeds silently vs what stops and asks
    verification.md         what "done" means; ground-truth before trusting docs
    eye-test.md             QA: verifying a change in the real running system
    review.md               the independent-review discipline
    linear.md               tracker conventions + the safety line
    delegation.md           subagents, parallel work, and swarm safety
    notifications.md        how you get pinged, and only when it matters
    documentation.md        one home for each question; no duplicate sources of truth
  integrations/             setup-from-zero playbooks
    linear.md · sentry.md · posthog.md · github-actions.md
  .claude/skills/onboarding/  the first-run interview
  state/                    STATE.md (live state) + decisions.md (settled decisions)
  plan/chats/               session handoffs
  knowledge/index.md        your project wiki (grows as you go)
```

## Philosophy in one paragraph

The human gate sits at **promote to production** and nowhere earlier. Everything before it is
autonomous and reversible; everything at and after it is your typed word. The tracker issue is the
brief, the lock, the evidence log, and your inbox, all at once. And every serious defect in a
codebase is found by a reviewer who did not write the code — so review is not optional, it is where
the quality comes from.

## License

MIT. See `LICENSE`. Use it, fork it, adapt it.
