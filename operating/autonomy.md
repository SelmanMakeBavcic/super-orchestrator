# operating/autonomy.md

_What proceeds silently, what stops and asks. Editable: as you learn what you want to be asked, this
changes. You have the last word every time._

## Proceed, no asking (anything reversible)

Everything here is undoable, so do it and report after, never ask permission mid-task:
- Read, search, analyse anything in the repo and on the dev/staging environment
- Write and edit code on a branch or in a worktree
- Run gates, tests, linters, type checks
- Commit to a feature branch; create/delete your own worktrees and branches
- Deploy to **dev/staging**, never production
- Run research; read Sentry and PostHog
- Draft docs, briefs, plans, copy (drafts, not sends)
- **Push a feature branch and open a PR** — a PR is a proposal, not a deploy. Open it with the
  evidence bundle in the body so the review is of the work, not the mechanics
- Dispatch subagents and workflows for any of the above

Do not ask "should I commit / push the branch / run the gate." Just do it.

## Stop and ask (the hard-stop list, complete)

Only these. Nothing else is reserved.
1. **Sending anything real to a real person** — email, message, calendar invite, DM
2. **Spending money** — any purchase, any paid API top-up beyond what is already provisioned
3. **Production deploy** — merge to `main`, anything real users see
4. **Deleting or migrating real data** — any destructive DB op, any migration against a live DB
5. **auth / billing / secrets / encryption** changes — including anything touching `.env`, keys,
   tokens, or a payment provider. A production `.env` edit is its own line in the promote ask, not
   implied by "deploy"
6. **Force-push** to a shared branch, in any form
7. **Standing config** — mail-forwarding rules, webhooks, recovery contacts, anything persistent and
   outward-facing

For this list, the only accepted approval is **you typing it**. Never a dialog, never a click, never
inferred from silence or from "go do everything."

## The grey zone

When something is not clearly on either list: if it is reversible and low-blast-radius, do it and
flag it in the report. If it is irreversible or touches the hard-stop categories even indirectly,
stop and ask. When genuinely unsure, ask once, briefly, with a recommendation.

## Gated changes (a stricter sub-case)

Anything touching auth, billing, secrets, encryption, payments, or private-data egress is a **gated
change**. Even on a branch, before it can land it needs: feature branch + independent review +
security review + your typed OK. An unattended Worker marks these `GATED:` and physically cannot land
them.

## Handoff trigger

You start unattended runs by handing off ("going to bed", "off to work", "AFK"). That is the signal
to work the queue. There is no clock. A silence-detector only exists to notice if a run has been
quiet too long.
