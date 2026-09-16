---
name: onboarding
description: Use on first run of super-orchestrator, or when the user types /onboard or asks to set up / configure this workflow for their project. Interviews the user about their project and how they work today, adapts the pipeline to them (keeping what already works), wires up the integrations they choose, and hands them a ranked list of the first improvements to their PR flow.
---

# Onboarding — make this workflow yours

You are setting up super-orchestrator for a new user and their project. The goal is not to impose the
whole system on day one. It is to **understand how they already work, keep what works, and graft the
pipeline onto the gaps** — so they ship more PRs, faster, at higher quality.

Your north star for them: **more PRs, faster, higher quality.** Every recommendation you make should
serve that.

## Before you start

Read `CLAUDE.md`, `soul.md`, and `operating/workflow.md` so you understand the system you are
adapting. Skim the current repo you are being dropped into (if there is one beside this): its
language, test setup, git branches, and whether it already has CI. You will tailor to what you find.

## The interview (one question at a time)

Ask **one question at a time** and wait for the answer — do not dump a form. Use their answers to
skip questions that no longer apply. Keep it to the essential set below; stop early if you have what
you need. This is the same discipline as the brainstorming skill: understand before you propose.

1. **Who and what.** What is your name (for `soul.md`), and what do you build? (web app / backend /
   mobile / library / data / mixed) Solo, or a small team?
2. **Stack.** Language(s), framework, test runner, and where it deploys. How does a change get to
   production today?
3. **How you start a task today.** Walk me through it: idea → shipped. Where does it begin — an
   issue, a note, straight into code? This is the most important answer; listen for where the pipeline
   attaches.
4. **Where PRs get slow or low-quality.** What actually hurts — reviews piling up, bugs slipping to
   prod, flaky tests, scope creep, no time to QA, context-switching? Rank the top two.
5. **Tools you already use vs start from zero.** For each of Linear, Sentry, PostHog, GitHub Actions:
   already using it, want to add it, or skip it?
6. **How much you want to stay in the loop.** Do you want to review every PR yourself, or let an AI
   reviewer gate most and only pull you in for the risky ones? (This sets the default review rigor.)
7. **Your quality bar.** In one or two specifics, what does "good" mean for this product? (secure by
   default / fast / accessible / well-tested / simple over clever) This becomes the reviewer's third
   verdict line.
8. **Your voice.** Any writing rules for how the orchestrator should talk and write (e.g. plain, no
   hype, no em dashes)? Any notification channel you want pings on?

## Map their workflow onto the pipeline

Before writing anything, tell them — briefly — how their current flow maps onto
`operating/workflow.md`, and where the highest-leverage additions are. Be concrete:

- If they have **no independent review step**, that is almost always the #1 quality lever — the whole
  system defaults to an independent AI reviewer on every PR (`operating/review.md`). Lead with it.
- If they **build straight into code with no ticket**, introduce the tracker issue as the brief +
  lock + evidence log, and the brainstorm→spec→tickets front of Loop B.
- If **bugs slip to prod**, lead with Loop A (Sentry/PostHog → triaged tickets) and the eye-test gate.
- If **PRs pile up**, lead with the batch-gate + serialized landing so review is not the bottleneck.
- Keep what works: if they already have good CI, or a review habit, or a tracker they like, adapt the
  docs to it rather than replacing it.

Do not propose the whole thing at once. Name the two or three changes that will move their number most.

## Write their config

Once they have confirmed the shape, write these files (show a diff / summary, do not silently
overwrite):

1. **`soul.md`** — replace every `{{...}}` placeholder with their name, project, writing rules, and
   quality bar. Keep the values section as-is unless they want to change it.
2. **`state/STATE.md`** — fill in the template: project name, stack, environments (dev vs prod and how
   they differ), current branch model, and the boot pointer. This is their live-state doc from now on.
3. **`PROJECT.md`** (create at repo root) — the durable facts about their project an agent needs:
   what it is, the stack, how to run it, how to test it (the gate command), how it deploys, and any
   conventions. Keep it short; it is read at boot.
4. **A setup checklist** — for each integration they chose, a checklist drawn from `integrations/*.md`
   with their `[you]` clicks called out. Put it in `state/STATE.md` under "Setup TODO" so it is
   visible until done.
5. **`CLAUDE.md`** — replace the `{{you}}` / `{{yourself}}` placeholders and the quality-bar line.

## Propose their first three improvements

End the session with a ranked, concrete list — the first three changes to their PR flow, each an
action they (or you) can take now, ordered by impact on speed + quality. For example:

1. "Add the independent-review step to your next PR — I'll run it as a subagent. Biggest quality lever."
2. "Create the Linear team + labels and file your current in-flight work as issues. I can do the labels
   via API once you make the key."
3. "Add the GitHub Actions gate so a red PR is caught before it merges."

Offer to start on #1 immediately.

## Guardrails during onboarding

- Do not connect anything or spend money without their say-so (`operating/autonomy.md`).
- Do not paste any secret they give you into a file — tell them where it goes (an env var) and move on.
- If they hand you a repo, do not push or open PRs during onboarding; this is setup, not building.
- Leave the repo runnable: after onboarding, `state/STATE.md` should have no `{{placeholders}}` left.
