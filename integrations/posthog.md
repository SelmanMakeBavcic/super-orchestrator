# integrations/posthog.md — set up PostHog from zero

PostHog gives you product analytics, error tracking, and (if you run LLM features) LLM analytics. It
is a second signal source for **Loop A** and the place you answer "is this feature actually used" and
"did that change help."

## 1. Create a project `[you]`

1. Sign up at posthog.com (free tier is generous; pick the EU cloud if that matters).
2. Create a project; copy the **project API key** (public, safe in the client) and note your host
   (`eu.posthog.com` or `us.posthog.com`).
3. Install the SDK. For a web app, set `VITE_PUBLIC_POSTHOG_KEY` (or your framework's equivalent) —
   and **confirm the deployed bundle actually carries it**, same trap as Sentry: a build with no key
   silently no-ops.

## 2. Turn on the pieces you want `[you]`

- **Product analytics** — autocapture, or a handful of deliberate events for the funnels you care
  about. Fewer, well-named events beat autocapture noise.
- **Error tracking** — catches client and server exceptions; a second net alongside Sentry.
- **Session replay** — optional; useful for reproducing a UX bug, but mind privacy (mask inputs).
- **LLM analytics** — if you call an LLM, PostHog's LLM observability tracks cost, latency, and token
  usage per call, and surfaces anomalies. Worth it the moment you ship an AI feature.

## 3. Feed Loop A

PostHog **Signals** and error tracking can be polled the same way as Sentry: a small unattended check
(a cron on your always-on box) that reads the PostHog API with a personal API key (a secret, kept in
the box env), applies the **same firewall** — one source id = one tracker issue, threshold +
rate-limit, metadata only — and files a triaged tracker issue. Ask the orchestrator to add a PostHog
check alongside the Sentry one; they share the dedup/threshold logic.

## 4. Privacy

PostHog can capture a lot. Mask sensitive inputs in replay, avoid sending PII as event properties, and
remember the safety line: nothing that identifies a real user goes into the tracker when a PostHog
signal is filed — counts and booleans only.

## Verify it works

- Fire a test event from dev, confirm it appears in the project.
- Confirm the deployed production bundle sends events (check the network tab or the live events feed),
  not just your local build.
- Run the Loop-A check once and confirm it files one deduped tracker issue for a real anomaly.
