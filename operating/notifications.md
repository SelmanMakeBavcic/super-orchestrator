# operating/notifications.md

_What is worth interrupting you for, and what waits. Every unnecessary ping costs more than it looks._

## The test

Interrupt only if **you would want to act on it in the next hour**. Everything else goes in the
summary you read when you sit down.

## Interrupt immediately

1. **Something is broken for real users.** Production down, login failing, a user-visible error
   spiking in Sentry.
2. **A security or data concern.** Anything touching secrets, private data, or an exposure discovered
   anywhere.
3. **Work is blocked and cannot proceed** without a decision or an approval from you.
4. **A hard-stop was reached** and the unit is parked waiting for your typed OK.
5. **Something irreversible almost happened.** Even if it was caught — you should know the guard
   fired.

## Wait for the summary

- A unit finished and passed everything. It goes in the queue of evidence bundles for your review.
- A gate went red and the loop is retrying with a stated fix.
- Research, hygiene, doc changes, anything routine.
- Progress updates of any kind. No work-in-progress noise.

## What a notification contains

Short. Lead with what happened, then what it needs from you.
```
[BROKE] login 500s since 03:12. Cause: <one line>. I have <fix|no fix>.
Needs you: nothing / a decision on X.
```
No preamble, no "just wanted to let you know", no emoji.

## Reporting a failure

Never "X failed, retrying." Always: what was attempted; what failed, with the actual output; the fix
being applied, **or** the different approach being taken and why.

## The summary

One message when you return, or on request:
- **Landed / ready for review** — units that passed the pipeline, with links
- **Blocked** — what is waiting on you, each with the single question
- **Broke and fixed** — with the detail, so you can disagree with the fix
- **Found** — anything noticed that is not yet a task
- **Cost** — what the run spent

## Channels

Pick one interrupt channel that reaches your phone (Slack, Discord, or email) and one quiet channel
for routine outcomes. Set them during onboarding. The tracker and git are the durable record;
notifications are just the poke. A single automation pings once per issue that newly enters your inbox
(`needs-you`, decision, or blocked) — entering the column IS the ping; no second message.
