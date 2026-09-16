# integrations/sentry.md — set up Sentry from zero

Sentry is the error signal that feeds **Loop A** (self-healing) in `operating/workflow.md`: a real
error becomes a triaged tracker issue, deduped and rate-limited so it never becomes a paging machine.

## 1. Create a project `[you]`

1. Sign up at sentry.io (free tier; pick the EU region if that matters to you).
2. Create a project for your app's language/framework; copy the **DSN**.
3. Install the SDK in your app and set the DSN via env (`SENTRY_DSN` server-side, and a separate
   public DSN for the web bundle if you have one). **Check the web bundle actually ships its DSN** —
   a dev build with no DSN silently no-ops, and you think you have error tracking when you do not.
4. Set `environment` (e.g. `production`, `dev`) and `release` (your commit SHA) on init, so issues
   are attributable to a deploy.

## 2. Wire suspect-commits + stack links `[you]`

**Settings → Integrations → GitHub.** Enable it and add code mappings so a stack trace links to the
line and Sentry can name the suspect commit. This alone makes triage much faster.

## 3. The bridge to your tracker (the important part)

On the free tier, Sentry → tracker is create-by-click. For the pipeline you want **automatic filing**,
which is a small script you run unattended (a cron on your always-on box), not an interactive
connector. Rules, each one a scar — put them in the script before it files anything:

- **One source id = one tracker issue.** Store the Sentry issue id on the tracker issue; check before
  creating. Never a second issue for the same group.
- **Threshold + rate-limit.** File on N occurrences or a severity floor, never on the first event. An
  orphaned monitor can otherwise fire hundreds of times.
- **Enrich, metadata only.** Attach the breadcrumb that names the real host/route, counts, and the
  environment. Never customer data, never a full user id, never a secret (the safety line).

Ask the orchestrator to scaffold `sentry-check.py --watch` for your setup: it reads Sentry's API with
a `SENTRY_AUTH_TOKEN` (a secret, kept in the box env), dedups on the issue id, and files via your
tracker's API. This is the ingest step of Loop A.

## 4. Cron liveness (optional but cheap)

Sentry Crons (or a free service like Healthchecks.io) turns "a scheduled job silently stopped" into a
signal. Add a check-in ping to each scheduled job; a missed check-in files a tracker issue the same
way. Set a threshold so a single flaky ping does not page you.

## 5. Seer / AI root cause (optional)

Sentry's AI root-cause draft can be attached to each filed issue as a starting hypothesis. It is
usage-priced; turn it on once the volume justifies it.

## Verify it works

- Throw a test error in dev, confirm it lands in Sentry with the right environment + release.
- Run the bridge once, confirm exactly one tracker issue is created and a second run does not
  duplicate it.
